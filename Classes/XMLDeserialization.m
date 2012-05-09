#import "XMLDeserialization.h"

#import "TouchXML.h"
#import "TVShow.h"
#import "utils.h"

static TVShow *parseShow(CXMLNode *showNode);

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

    result.name = name;
    result.id = showId;
    result.episodes = [NSArray array];

    return result;
}


