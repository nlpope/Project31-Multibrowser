//  File: AVPlayer+Ext.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

import Foundation
import AVKit
import AVFoundation

extension AVPlayer
{
    var isPlaying: Bool { return rate != 0 && error == nil }
}
