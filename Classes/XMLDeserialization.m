#import "XMLDeserialization.h"

#import "TouchXML.h"
#import "TVShow.h"
#import "utils.h"

static TVShow *parseShow(CXMLNode *showNode);

NSString *parseImageUrl(NSData *xmlData)
{    
    NSError *e = nil;
    
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:xmlData options:0 error:&e];
 
    NSString *image = [[NSString alloc] init];
    if (e) {
        DLOG("error = %@", [e localizedDescription]);
        return image;
    }
    
    CXMLNode *node = [document nodeForXPath:@"Show" error:nil];    
        
    image = [[node nodeForXPath:@"image" error:nil] stringValue];
    
    return image;
}

NSArray *parseSearchResults(NSData *xmlData)
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    NSError *e = nil;

    CXMLDocument *document = [[CXMLDocument alloc] initWithData:xmlData options:0 error:&e];

    if (e) {
        DLOG("error = %@", [e localizedDescription]);
        return results;
    }

    for (CXMLNode *showNode in [document nodesForXPath:@"Results/show" error:nil]) {
        [results addObject:parseShow(showNode)];
    }

    return results;
}

static TVShow *parseShow(CXMLNode *showNode)
{
    TVShow *result = [[TVShow alloc] init];

    NSString *name = [[showNode nodeForXPath:@"name" error:nil] stringValue];
    int showId = [[[showNode nodeForXPath:@"showid" error:nil] stringValue] intValue];
    NSString *link = [[showNode nodeForXPath:@"link" error:nil] stringValue];

    result.name = name;
    result.num = showId;
    result.episodes = [NSArray array];
    result.link = link;

    return result;
}


