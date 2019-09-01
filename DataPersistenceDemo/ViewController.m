//
//  ViewController.m
//  DataPersistenceDemo
//
//  Created by 草帽~小子 on 2019/8/31.
//  Copyright © 2019 OnePiece. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>//引入数据库
#import <FMDB/FMDB.h>
#import <Security/Security.h>

@interface ViewController ()

@end

static sqlite3 *db = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self sandbox];
    
    //[self sqlite];
    
    //[self fmdb];
    
    [self keychain];
    
    // Do any additional setup after loading the view.
}

- (void)sandbox {
    //获取文件的路径
    //1，获取Home目录路径的函数，指的就是Document、Library、tmp的共同上一个文件夹
    NSString *homeDir = NSHomeDirectory();
    NSString *homePath = [homeDir stringByAppendingPathComponent:@"Document"];
    
    //2、通过名字获取
    /*  NSDocumentDirectory:Document
     *  NSCachesDirectory:Library/Caches
     *  NSLibraryDirectory:
     *                   Library/Caches
     *                   Library/Preferences,NSUserDefault形成的plist文件存储在当前文件夹下
     *  NSTemporaryDirectory:tmp
     */
    
    NSArray *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [[dir firstObject] stringByAppendingPathComponent:@"DirectoryForImg"];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"img"];
    //用NSFileManager，单例，可以创建Directory文件夹
    BOOL isDir = false;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取Document文件下的所有文件夹，两种方式
//    NSArray *contentArr = [fileManager contentsOfDirectoryAtPath:[dir firstObject] error:nil];
//    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:[dir firstObject]];
//    NSLog(@"----%@===%@", contentArr, [enumerator allObjects]);
    
    //创建文件夹directory
    //[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //创建文件file
    //[fileManager createFileAtPath:filePath contents:NSData* attributes:nil];
    //移动
    //[fileManager moveItemAtPath:filePath toPath:newPath error:&error];
    //复制文件
    //[fileManager copyItemAtPath:filePath toPath:newPath error:&error];
    //删除文件
    //[fileManager removeItemAtPath:filePath error:nil];
    if ([fileManager fileExistsAtPath:dirPath isDirectory:&isDir]){//可以判断存在的文件类型是文件夹还是文件
        if (isDir) {
            NSLog(@"是一个文件夹Directory");
            //可以写入字符串、数组、字典、NSData等
            NSString *write = @"赵";
            NSArray *arr = @[@"1", @"2", @"3"];
            NSDictionary *dic = @{@"a":@"1", @"b":@"2"};
            //写入，如果没有会自动创建file文件
            //最好用个判断，舒服
            BOOL isExist = [fileManager fileExistsAtPath:filePath];
            if (isExist) {
                [write writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                [arr writeToFile:filePath atomically:YES];//后面的会覆盖前面的写入
                [dic writeToFile:filePath atomically:YES];//后面的会覆盖前面的写入
            }
            //NSLog(@"home=======%@\n-------%@", dirPath, filePath);
            
        }else {
            NSLog(@"是一个文件File");
        }
    }
    
    //读取
//    NSData *data1 = [fileManager contentsAtPath:filePath];
//
//    NSData *data2 = [NSData dataWithContentsOfFile:filePath];
//    NSData *data3 = [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
//
//    NSDictionary *myData = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//
//    //类方法
//    NSString * str1 = [NSString stringWithContentsOfFile:filePath
//                                                encoding:NSUTF8StringEncoding
//                                                   error:nil];
    //其它
    NSString * urlString = @"http://www.baidu.com/img/baidu_logo_fqj_10.gif";
    //[self getFileNameWithURLString:urlString];
    //[self getFileNameWithFilePath:urlString];
    //取得一个目录下得所有文件的名子
//    NSArray *files = [fileManager subpathsAtPath: filePath];
//    NSArray *file = [fileManager subpathsOfDirectoryAtPath: docDir error:nil];

}


- (void)sqlite {
    
    [self openDB];
    
    //[self createTable];
    
    //[self update];
    
    //[self insertInto];
    
    //[self deleteData];
    
    //[self select];
    
    
    //[self closeDB];
}

// MARK: CREATE TABLE
- (void)createTable {
    /*
     *class Student {
     String id;
     String name;
     String sex;
     String number;
     String classid;
     }
     class Grade {
     String id;
     String name;
     String teacher;
     }
     *
     */
    
    sqlite3 *newDB = [self openDB];
    //create table if not exists (字段名1 字段类型1, 字段名2 字段类型2,以此类推 …) ;
    const char *sql = "CREATE TABLE IF NOT EXISTS StudenT (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, name text NOT NULL, score real DEFAULT 0, sex text DEFAULT '不明')";
    //执行sqlite
    int create = sqlite3_exec(newDB, sql, NULL, NULL, NULL);
    //执行结果
    if (create == SQLITE_OK) {
        NSLog(@"创建表成功");
    }else {
        NSLog(@"创建表失败");
        //sqlite3_free(0);
    }
    
    //[self closeDB];
}

// MARK: INSERT INTO
- (void)insertInto {
    //insert into 表名 (字段1, 字段2, 以此类推…) values (字段1的值, 字段2的值,以此类推 …)
    //插入单条数据
    const char *sql = "INSERT INTO StudenT(name,score,sex) VALUES ('qian', 20, '男');";
    //同时插入多条数据
//    NSMutableString * mstr = [NSMutableString string];
//    for (int i = 0; i < 50; i++) {
//        NSString * name = [NSString stringWithFormat:@"name%d", i];
//        CGFloat score = arc4random() % 101 * 1.0;
//        NSString * sex = arc4random() % 2 == 0 ? @"男" : @"女";
//        NSString * tsql = [NSString stringWithFormat:@"INSERT INTO t_Student         (name,score,sex) VALUES ('%@',%f,'%@');", name, score, sex];
//        [mstr appendString:tsql];
//    }
    
    int ret = sqlite3_exec(db, sql, NULL, NULL, NULL);
    //3.判断执行结果
    if (ret==SQLITE_OK) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    
    //[self closeDB];
}

// MARK: UPDATE
- (void)update {
    //update 表名 set 字段1 = 字段1的新值, 字段2 = 字段2的新值,以此类推 … ,条件可以有多个用and或者or连接
    const char *sql = "UPDATE StudenT set score = 90, sex = '女' where name = 'qian'";
    sqlite3_stmt *statement = nil;
    //检验合法性
    int result = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"更新信息完成");
        }
    }else {
        NSLog(@"更新信息不合法");
    }
    sqlite3_finalize(statement);
    //[self closeDB];
}

// MARK: DELETE
- (void)deleteData {
    sqlite3 *newDB = [self openDB];
    sqlite3_stmt *statement = nil;
    NSString *sqlStr = @"DELETE FROM StudenT WHERE NAME = 'qian'";
    int result = sqlite3_prepare_v2(newDB, sqlStr.UTF8String, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"删除操作完成");
        }
    } else {
        NSLog(@"删除操作不合法");
    }
    sqlite3_finalize(statement);
    //[self closeDB];
}

// MARK: SELECT
- (void)select {
    sqlite3_stmt *statement = nil;
    const char *sql = "SELECT * FROM StudenT";
    int result = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    if (result == SQLITE_OK) {
        //遍历查询结果
//        if (!(sqlite3_step(statement) == SQLITE_DONE)) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int ID = sqlite3_column_int(statement, 0);
                const unsigned char *name = sqlite3_column_text(statement, 1);
                int score = sqlite3_column_int(statement, 2);
                const unsigned char *sex = sqlite3_column_text(statement, 3);
                NSLog(@"ID = %d , name = %@ , score = %d , sex = %@", ID, [NSString stringWithUTF8String:(const char *) name], score, [NSString stringWithUTF8String:(const char *)sex]);
            }
//        }else {
//            NSLog(@"查询语句完成");
//        }
    }else {
        NSLog(@"查询语句不合法");
    }
    sqlite3_finalize(statement);
    
}


// MARK: OPEN
- (sqlite3 *)openDB {
    if (!db) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:@"user.sqlite"];
        NSLog(@"%@",dbPath);
        //判断document中是否有sqlite文件
        int result = sqlite3_open([dbPath UTF8String], &db);
        if (result == SQLITE_OK) {
            NSLog(@"打开数据库");
        }else {
            NSLog(@"打开数据库失败！");
        }
    }
    return db;
}

- (void)closeDB {
    sqlite3_close(db);
    
    if (sqlite3_close(db) == SQLITE_OK) {
        NSLog(@"关闭成功!");
        db = nil;
    }else {
        NSLog(@"关闭失败!");
    }
}

- (void)fmdb {
//    三个核心类：
//    1、FMDatabase：表示一个SQLite数据库，用于执行sql语句；
//    2、FMResultSet：FMDatabase执行查询得到的结果集；
//    3、FMDatabaseQueue：多线程用的查询或更新队列；
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    FMDatabase *daBase = [FMDatabase databaseWithPath:path];
    [daBase open];
    // create table
    NSString *createSqlStr = @"create table if not exists test_table_name(id integer primary key autoincrement,test_name_key char)";
    [daBase executeUpdate:createSqlStr];
    
    // insert table
//    NSString *insertSqlStr = @"insert into test_table_name(test_name_key) values('anyname')";
//    [db executeUpdate:insertSqlStr];
    
    
//    NSString *insertSqlStr2 = @"insert into test_table_name(test_name_key) values(?)";
//    [db executeUpdate:insertSqlStr2, @"another_name"];
    
    //查询
//    FMDatabaseQueue *sqlQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//    [sqlQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        NSString *selectSqlStr = @"select id, test_name_key FROM test_table_name";
//        FMResultSet *result = [db executeQuery:selectSqlStr];
//        while ([result next]) {
//            int value_id = [result intForColumn:@"id"];
//            NSString *value_name = [result stringForColumn:@"test_name_key"];
//            NSLog(@"id:%d, name:%@", value_id, value_name);
//        }
//    }];
    
    
}

// MARK: keychain
- (void)keychain {
    
}



-(void)getFileNameWithURLString:(NSString *)urlString{
    
    //方法一：最直接。
    NSString *fileName = [urlString lastPathComponent];
    NSLog(@"%@",fileName);
    
    //方法二：根据字符分割。
    NSArray *SeparatedArray =[urlString componentsSeparatedByString:@"/"];
    NSString *filename = [SeparatedArray lastObject];
    NSLog(@"%@",filename);
    
    //方法三：将链接看成路径。
    NSArray *urlCom = [[NSArray alloc]initWithArray:[urlString pathComponents]];
    NSLog(@"%@",[urlCom lastObject]);
    
    //方法四：NSRange.它在截取二进制文件的时候十分方便。
    NSString * fileName3;
    NSRange range = [urlString rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        fileName3 = [urlString substringFromIndex:range.location+1];
        if([[fileName lowercaseString] hasSuffix:@".gif"])
        {
            NSLog(@"%@",fileName);
        }
    }
}

- (void)getFileNameWithFilePath:(NSString *)filePath{
    //获取文件名（带后缀）
    NSString *fileName = [filePath lastPathComponent];
    NSLog(@"%@",fileName);
    
    //获得文件名（不带后缀）
    fileName = [fileName  stringByDeletingPathExtension];
    NSLog(@"%@",fileName);
    
    // 获得文件的后缀名（不带'.'）
    NSString * pathExtension = [filePath pathExtension];
    NSLog(@"%@",pathExtension);
}



@end
