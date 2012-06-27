#import "XMLDeserialization.h"

#import "TouchXML.h"
#import "TVShow.h"
#import "Episode.h"
#import "utils.h"

static TVShow *parseShow(CXMLNode *showNode);
static Episode *parseEpisode(CXMLNode *showNode);

NSArray *parseEpisodes(NSData *xmlData)
{
    NSMutableArray *results = [[NSMutableArray alloc] init];    
    NSError *e = nil;
    
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:xmlData options:0 error:&e];
    
    if (e) {
        DLOG("error = %@", [e localizedDescription]);
        return results;
    }
    
    for (CXMLNode *node in [document nodesForXPath:@"Data/Episode" error:nil]) {
        [results addObject:parseEpisode(node)];
    }
    
    return results;    
}

static Episode *parseEpisode(CXMLNode *node)
{
    Episode *result = [[Episode alloc] init];
    
    NSString *name = [[node nodeForXPath:@"EpisodeName" error:nil] stringValue];
    
    int epId = [[[node nodeForXPath:@"id" error:nil] stringValue] intValue];
    int season = [[[node nodeForXPath:@"Combined_season" error:nil] stringValue] intValue];
    int episode = [[[node nodeForXPath:@"Combined_episodenumber" error:nil] stringValue] intValue];

    NSString *airDate = [[node nodeForXPath:@"FirstAired" error:nil] stringValue];
    NSString *description = [[node nodeForXPath:@"Overview" error:nil] stringValue];
    NSString *image = [[node nodeForXPath:@"filename" error:nil] stringValue];

    result.name = name;
    result.num = epId;
    result.combinedNum = episode;
    result.seasonNum = season;

    result.airDate = airDate;
    result.description = description;
    result.image = image;
    
    DLOG("Parsed EPISODE: Name: %@ Id: %d description: %@", result.name, result.num, result.description);
    
    return result;
}

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

NSString *parseStatus(NSData *xmlData)
{    
    NSError *e = nil;
    
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:xmlData options:0 error:&e];
    
    NSString *status = [[NSString alloc] init];
    if (e) {
        DLOG("error = %@", [e localizedDescription]);
        return status;
    }
    
    CXMLNode *node = [document nodeForXPath:@"Data/Series" error:nil]; 
    status = [[node nodeForXPath:@"status" error:nil] stringValue];
    
    DLOG("STATUS parsed: %@", status);
    
    return status;
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


