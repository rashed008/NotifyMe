//
//  Audio.swift
//  NotifyMe
//
//  Created by RASHED on 10/6/22.
//

import Foundation

import AVFoundation

func configureAudioSession() {
  let session = AVAudioSession.sharedInstance()
  do {
    try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
  } catch (let error) {
    print("Getting Error while configuring audio session: \(error)")
  }
}

func startAudio() {
  print("Starting audio")
}

func stopAudio() {
  print("Stopping audio")
}
