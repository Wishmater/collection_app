# Concepts
Brief explanation of the very simple concepts used in the app that will allow you to organize any kind of collection.  

### Collection
Represents a collection type, these should be wide bags like "Music" or "Manga", separating content that has nothing to do with each other. Each collection also has a different root directory in local storage, and also multiple settings that are set collection-wide.  
TODO: 1 QUESTION: can different collections share the same tags? If so, it's easy to filter cross-collections, so collection will become only a settings and directory thing  

### Item
An item represents a file, so a picture, a song, a video, etc. The item will have the name, the path to the file itself, and all metadata we need to save to make filtering and processing fast.  
Items have a type, which can be one of: video, audio or image. Default software to open each type can be configured globally or per-collection. Items can be of unknown type if we fail to infer it on import. There is also a special type of item "Album".  

#### Albums
An album is an item that contains other items. This is only intended to be used for items that are tightly bound together (and usually ordered), like songs in a music album, pages in a manga, or episodes in a show.  
For other classifications, like artist, genre, etc., prefer using tags.  
TODO: 1 can albums be nested?  
TODO: 1 should there be a way to declare "cover" items (of any) that will represent their album? If there are no covers declared, we can still use all of them by default.  

### Tag
A tag can be used to express additional info of an item, like artist, genre/style, etc. Tags power the filtering systems which are kinda the whole point of this project, allowing you to dynamically create lists of items that meet certain criteria, which can be useful to create music playlists and more.  

#### Nesting Tags
Tags can have parents and children. This can be used to declare tag "types", for example there can be an "Author" tag which parents all actual instances like "Black Sabbath" or "Metallica", visually expressing the kind of tag it is. This can also be used to declare that a tag is a subtype of another type, for example you could have a "Rock" tag that has children like "Metal" and "Soft", and then metal could have as children other subgenres; this way you can filter by a high level tag and it will include all its descendants.  

### Ratings
Sometimes you want to have information about an item that is not yes/no. For example, maybe you want to rate an item out of 10, and then use this rating to repeat the good items more when creating randomized playlists. Tags don't solve this use case, so we provide 2 specific values "Rating" and "Priority"  
TODO: 1 Should ratings just be "Numeric tags", so that we can arbitrarily declare any number of them?  
