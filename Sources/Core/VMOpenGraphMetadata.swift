//
//  VMOpenGraphMetadata.swift
//  Noul
//
//  Created by max on 2021/10/14.
//

#if canImport(Foundation)

import Foundation

/// https://ogp.me/
public enum VMOpenGraphMetadata: String, CaseIterable {
  
  // Basic Metadata
  case title
  case type
  case image
  case url
  
  // Optional Metadata
  case audio
  case description
  case determiner
  case locale
  case localeAlternate = "locale:alternate"
  case siteName = "site_name"
  case video
  
  // Structured Properties
  case imageUrl = "image:url"
  case imageSecureUrl = "image:secure_url"
  case imageType = "image:type"
  case imageWidth = "image:width"
  case imageHeight = "image:height"
  case imageAlt = "image:alt"
  
  // Music
  case musicDuration = "music:duration"
  case musicAlbum = "music:album"
  case musicAlbumDisc = "music:album:disc"
  case musicAlbumTrack = "music:album:track"
  case musicMusicia = "music:musician"
  case musicSong = "music:song"
  case musicSongDisc = "music:song:disc"
  case musicSongTrack = "music:song:track"
  case musicReleaseDate = "music:release_date"
  case musicPlaylist = "music.playlist"
  case musicCreator = "music:creator"
  case musicRadioStation = "music.radio_station"
  
  // Video
  case videoActor = "video:actor"
  case videoActorRole = "video:actor:role"
  case videoDirector = "video:director"
  case videoWriter = "video:writer"
  case videoDuration = "video:duration"
  case videoReleaseDate = "video:release_date"
  case videoTag = "video:tag"
  case videoSeries = "video:series"
  
  // No Vertical
  case articlePublishedTime = "article:published_time"
  case articleModifiedTime = "article:modified_time"
  case articleExpirationTime = "article:expiration_time"
  case articleAuthor = "article:author"
  case articleSection = "article:section"
  case articleTag = "article:tag"
  
  case bookAuthor = "book:author"
  case bookIsbn = "book:isbn"
  case bookReleaseDate = "book:release_date"
  case bookTag = "book:tag"
  
  case profileFirstName = "profile:first_name"
  case profileLastName = "profile:last_name"
  case profileUsername = "profile:username"
  case profileGender = "profile:gender"
}

#endif
