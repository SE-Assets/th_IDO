public with sharing  class tthTravelerCommunityUtils {

  @InvocableMethod(label='Get Community URL' description='Returns the complete url for the specified community')
  public static List<String> getCommunityURL(List<String> communityName) {

    List<String> urls = new List<String>();
    Domain primaryDomain = [SELECT Domain from Domain where DomainType = 'DNS'];
    Network communityPrefix = [SELECT UrlPathPrefix FROM Network where Name =: communityName.get(0)];
    String communityURL = 'https://' + primaryDomain.Domain + '/' + communityPrefix.UrlPathPrefix;

    urls.add(communityURL);

    return urls;
  }



}
