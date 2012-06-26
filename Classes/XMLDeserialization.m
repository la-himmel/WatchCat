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
    
    CXMLNode *node = [document nodeForXPath:@"Data/Series" error:nil];    
        
    image = [[node nodeForXPath:@"fanart" error:nil] stringValue];
    
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

    for (CXMLNode *showNode in [document nodesForXPath:@"Data/Series" error:nil]) {
        [results addObject:parseShow(showNode)];
    }

    return results;
}

static TVShow *parseShow(CXMLNode *showNode)
{
    TVShow *result = [[TVShow alloc] init];

    NSString *name = [[showNode nodeForXPath:@"SeriesName" error:nil] stringValue];
    int showId = [[[showNode nodeForXPath:@"seriesid" error:nil] stringValue] intValue];
    NSString *description = [[showNode nodeForXPath:@"Overview" error:nil] stringValue];

    result.name = name;
    result.num = showId;
    result.description = description;
    
//    DLOG("Parsed: Name: %@ Id: %d description: %@", result.name, result.num, result.description);

    return result;
}


