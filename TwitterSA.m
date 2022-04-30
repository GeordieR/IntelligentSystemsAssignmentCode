%Enter API Keys Here from Twitter Developer Portal
consumerkey = '';
consumersecret = '';
accesstoken = '';
accesstokensecret = '';
bearertoken = '';

%Enter Search Parameters
searchText = 'Covid19';
maxResults = '100';

%Create Connection to Twitter
URL = append('https://api.twitter.com/2/tweets/search/recent?query=',searchText,'&tweet.fields=lang&max_results=',maxResults);

options = weboptions;
options.RequestMethod = 'GET';
options.ContentType = 'json';
options.HeaderFields = {
    'Authorization', ['Bearer',' ',bearertoken]
    };

%Make API Call to Twitter
response = webread(URL, options);

%Convert Struct to Array
tweets = struct2cell(response.data);

%Remove Tweet IDs Row
tweets(1,:) = [];

%Create Array for Sentiment Analysis
results = {};

%Iterate Tweets Array and Perform Sentiment Analysis
for k =1:size(tweets,2)

    documents = tokenizedDocument(tweets(2, k));
    vaderScore = vaderSentimentScores(documents);

    %Filter to English Tweets
    if (strcmp(string(tweets(1,k)),'en'))

        %Add Score and Tweet Text to Results Array
        results(end+1, :) = {vaderScore, tweets(2,k)};

    end

end
