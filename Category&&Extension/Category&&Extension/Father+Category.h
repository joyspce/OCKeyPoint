//
//  Father+Category.h
//  Category&&Extension
//
//  Created by JiWuChao on 2018/8/21.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Father.h"

@interface Father (Category)

@property (nonatomic,copy) NSString *idNumber;


/*
 category动态扩展了原来类的方法，在调用者看来好像原来类本来就有这些方法似的，有两个事实：
 
 不论有没有import category 的.h，都可以成功调用category的方法，都影响不到category的加载流程，import只是帮助了编译检查和链接过程
 runtime加载完成后，category的原始信息在类结构里将不会存在
 这需要探究下runtime对category的加载过程，这里就简单说一下
 
 objc runtime的加载入口是一个叫_objc_init的方法，在library加载前由libSystem dyld调用，进行初始化操作
 调用map_images方法将文件中的imagemap到内存
 调用_read_images方法初始化map后的image，这里面干了很多的事情，像load所有的类、协议和category，著名的+ load方法就是这一步调用的
 仔细看category的初始化，循环调用了_getObjc2CategoryList方法，这个方法拿出来看看：
 …
 #define GETSECT(name, type, sectname)                                   \
 type *name(const header_info *hi, size_t *outCount)  \
 {                                                                   \
 unsigned long byteCount = 0;                                    \
 type *data = (type *)                                           \
 getsectiondata(hi->mhdr, SEG_DATA, sectname, &byteCount);   \
 *outCount = byteCount / sizeof(type);                           \
 return data;                                                    \
 }
 
 // ... //
 
 GETSECT(_getObjc2CategoryList, category_t *, "__objc_catlist");
 眼熟的__objc_catlist，就是上面category存放的数据段了，可以串连起来了
 
 在调用完_getObjc2CategoryList后，runtime终于开始了category的处理，简化的代码如下
 
 // Process this category.
 // First, register the category with its target class.
 // Then, rebuild the class's method lists (etc) if
 // the class is realized.
 BOOL classExists = NO;
 if (cat->instanceMethods ||  cat->protocols  ||  cat->instanceProperties)
 {
     addUnattachedCategoryForClass(cat, cls, hi);
     if (isRealized(cls)) {
             remethodizeClass(cls);
             classExists = YES;
         }
     }
 
     if (cat->classMethods  ||  cat->protocols )
     {
         addUnattachedCategoryForClass(cat, cls->isa, hi);
         if (isRealized(cls->isa)) {
         remethodizeClass(cls->isa);
     }
 }
 首先分成两拨，一拨是实例对象相关的调用addUnattachedCategoryForClass，一拨是类对象相关的调用addUnattachedCategoryForClass，然后会调到attachCategoryMethods方法，这个方法把一个类所有的category_list的所有方法取出来组成一个method_list_t **，注意，这里是倒序添加的，也就是说，新生成的category的方法会先于旧的category的方法插入
 
 static void
 attachCategoryMethods(class_t *cls, category_list *cats,
 BOOL *inoutVtablesAffected) {
     if (!cats) return;
     if (PrintReplacedMethods) printReplacements(cls, cats);
 
     BOOL isMeta = isMetaClass(cls);
     method_list_t **mlists = (method_list_t **)
     _malloc_internal(cats->count * sizeof(*mlists));
 
     // Count backwards through cats to get newest categories first
     int mcount = 0;
     int i = cats->count;
     BOOL fromBundle = NO;
     while (i--) {
     method_list_t *mlist = cat_method_list(cats->list[i].cat, isMeta);
     if (mlist) {
         mlists[mcount++] = mlist;
         fromBundle |= cats->list[i].fromBundle;
     }
 }
 
 attachMethodLists(cls, mlists, mcount, NO, fromBundle, inoutVtablesAffected);
 
 _free_internal(mlists);
 
 }
 
 生成了所有method的list之后，调用attachMethodLists将所有方法前序添加进类的方法的数组中，也就是说，如果原来类的方法是a,b,c，类别的方法是1,2,3，那么插入之后的方法将会是1,2,3,a,b,c，也就是说，原来类的方法被category的方法覆盖了，但被覆盖的方法确实还在那里。
 
 以上 ：
    总体的顺序是 ：倒叙取出category中的方法列表，生成一个中间数组 ，然后中间数组 正序 添加到 原来类的方法列表中
 
 如果类别的方法是 [m1,m2,m3] 生成的中间数组 是[m3,m2,m1] 如果原来类的生成方法列表是 [ma,mb,m3]
 合成之后 就是 [m1,m2,m3,ma,mb,m3] 在方法查找的时候是从前往后查找 首先查到的是 category中的m3 此时就会结束 不会继续向下查找，也就是原来类的方法被 category中的同名方法覆盖了
 
 
 
 
 */

- (void)goShoping;

- (void)goHome;

@end
