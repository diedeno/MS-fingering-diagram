//=============================================================================
//  Fingering Diagram Plugin
//
//  Add instrument fingering diagrams to the score
//
//  Requires Fiati music font that can found here:
//     https://github.com/eduardomourar/fiati
//
//  Copyright (c) 2019-2023 Eduardo Rodrigues
//
// 20250910 adapted for MuseScore >= 4.4 by Diego Denolf (graffesmusic)
// set version to 2.0
// Needs an adapted Fiati font with Advance Width = 1, zero width fonts do not display properly in Qt6.x  
// 20250916 denolfd : added fingerings for Brass instruments.
//
// license GPL-3.0
//
//=============================================================================
import QtQuick 2.15
import MuseScore 3.0

MuseScore {
	
	version: '2.0'
    description: 'Add instrument fingering diagrams to the score'
	requiresScore: true

	/**
	* Class constructor used to create a new musical part fingering containing its type, range,
	* mapping, transposition, etc.
	*/
    
	function fingeringConstructor(part) {
		this.part = part || {};
		this.instrument = null;
		this.range = {};
		this.transpose = 0;
		this.base = '';
		this.mapping = [];
		this.allKeysPressed = '';
        
       
		/**
		* Populate dictionary mapping from notes pitch
		* to character sequence in the font.
		*/
        
		this._populate = function(instrument) {
			if (instrument === 'wind.flutes.flute' || instrument === 'wind.flutes.flute.alto' || instrument === 'flute' || instrument === 'alto-flute') {
				this.instrument = 'flute'; // Default: Flute
				this.range = {
					minPitch: 59, // B3 - For B foot flute
					maxPitch: 105, // A7
				};
				this.base = '\uE000\uE001\uE002\uE003'; // To add open holes (\uE004)
				this.mapping = [
					// 1st Octave (B3-B4)
					'\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012\uE014\uE015\uE016','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012\uE014\uE015','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012\uE014','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE013','\uE007\uE008\uE009\uE00A\uE012\uE013','\uE007\uE008\uE009\uE00A\uE013','\uE007\uE008\uE009\uE00A\uE00B\uE013','\uE007\uE008\uE009\uE013','\uE007\uE008\uE00E\uE013','\uE007\uE008\uE013',
					// 2nd Octave (C5-B5)
					'\uE008\uE013','\uE013','\uE007\uE009\uE00A\uE00E\uE010\uE012','\uE007\uE009\uE00A\uE00E\uE010\uE012\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE013','\uE007\uE008\uE009\uE00A\uE012\uE013','\uE007\uE008\uE009\uE00A\uE013','\uE007\uE008\uE009\uE00A\uE00B\uE013','\uE007\uE008\uE009\uE013','\uE007\uE008\uE00E\uE013','\uE007\uE008\uE013',
					// 3nd Octave (C6-B6)
					'\uE008\uE013','\uE013','\uE007\uE009\uE00A\uE013','\uE007\uE008\uE009\uE00A\uE00B\uE00E\uE010\uE012\uE013','\uE007\uE008\uE009\uE00E\uE010\uE013','\uE007\uE008\uE00A\uE00E\uE013','\uE007\uE008\uE00A\uE012\uE013','\uE008\uE009\uE00A\uE013','\uE009\uE00A\uE00B\uE013','\uE007\uE009\uE00E\uE013','\uE007\uE00F\uE00E','\uE007\uE008\uE00A\uE011',
					// 4th Octave (C7-A7)
					'\uE008\uE009\uE00A\uE00B\uE00E','\uE009\uE00E\uE012\uE014\uE015','\uE007\uE009\uE00A\uE00E\uE010\uE015','\uE007\uE00A\uE00F\uE00E\uE014\uE015','\uE007\uE009\uE00A\uE00B\uE00F\uE011\uE012\uE015\uE016','\uE009\uE011\uE012\uE013\uE014','\uE007\uE00B\uE00E\uE012\uE013\uE014','\uE007\uE009\uE00A\uE00B\uE00F\uE010','\uE007\uE009\uE00A\uE00B\uE00F\uE010\uE012\uE014\uE015\uE016','\uE007\uE009\uE00A\uE00B\uE00F\uE021\uE010\uE012\uE014\uE015\uE016',
				];
				this.allKeysPressed = '\uE000\uE001\uE002\uE003\uE006\uE007\uE008\uE009\uE00A\uE00B\uE00C\uE00D\uE00E\uE00F\uE010\uE011\uE012\uE013\uE014\uE015\uE016\uE017';
				if (instrument === 'wind.flutes.flute.alto' || instrument === 'alto-flute') {
					this.transpose = 5;
				}
			} else if (instrument === 'wind.flutes.flute.piccolo' || instrument === 'piccolo') {
				this.instrument = 'piccolo'; // Default: Piccolo
				this.range = {
					minPitch: 74, // D4 (written)
					maxPitch: 108, // C7
				};
				this.base = '\uE000';
				this.mapping = [
					// 1st Octave (D4-B4)
					'\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE012\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE013','\uE007\uE008\uE009\uE00A\uE012\uE013','\uE007\uE008\uE009\uE00A\uE013','\uE007\uE008\uE009\uE00A\uE00B\uE013','\uE007\uE008\uE009\uE013','\uE007\uE008\uE00E\uE013','\uE007\uE008\uE013',
					// 2nd Octave (C5-B5)
					'\uE008\uE013','\uE013','\uE007\uE009\uE00A\uE00E\uE010\uE012','\uE007\uE009\uE00A\uE00E\uE010\uE012\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE010\uE013','\uE007\uE008\uE009\uE00A\uE00E\uE013','\uE007\uE008\uE009\uE00A\uE012\uE013','\uE007\uE008\uE009\uE00A\uE013','\uE007\uE008\uE009\uE00A\uE00B\uE013','\uE007\uE008\uE009\uE013','\uE007\uE008\uE00E\uE013','\uE007\uE008\uE013',
					// 3nd Octave (C6-B6)
					'\uE008\uE013','\uE013','\uE007\uE009\uE00A\uE013','\uE007\uE008\uE009\uE00A\uE00B\uE00E\uE010\uE012\uE013','\uE007\uE008\uE009\uE00E\uE010\uE013','\uE007\uE008\uE00A\uE00E\uE013','\uE007\uE008\uE00A\uE012\uE013','\uE008\uE009\uE00A\uE013','\uE009\uE00A\uE00B\uE013','\uE007\uE009\uE00E\uE013','\uE007\uE00F\uE00E','\uE007\uE008\uE00A\uE011',
					// 4th Octave (C7)
					'\uE008\uE009\uE00A\uE00B\uE00E',
				];
				this.allKeysPressed = '\uE000\uE006\uE007\uE008\uE009\uE00A\uE00B\uE00C\uE00D\uE00E\uE00F\uE010\uE011\uE012\uE013';
			} else if (instrument === 'wind.reed.clarinet.eflat' || instrument === 'wind.reed.clarinet.d'
				|| instrument === 'wind.reed.clarinet.bflat' || instrument === 'wind.reed.clarinet.basset'
				|| instrument === 'wind.reed.clarinet.alto' || instrument === 'wind.reed.clarinet.bass'
                || instrument === 'eb-clarinet'  || instrument === 'd-clarinet' 
                || instrument === 'bb-clarinet' || instrument === 'basset-clarinet' || instrument === 'alto-clarinet' || instrument === 'bb-bass-clarinet')
                 {
				this.instrument = 'eb-clarinet'; // Default: Sopranino Clarinet in Eb
				this.range = {
					minPitch: 54, // D#3 (written)
					maxPitch: 108, // A7
				};
				this.base = '\uE0A0';
				this.mapping = [
					// 1st Octave (D#3-B4)
					'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AD\uE0B2\uE0B3\uE0B5\uE0BA',
					[
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AD\uE0B2\uE0B3\uE0B5\uE0B9',  // E 'LR'
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AD\uE0B2\uE0B3\uE0B5',        // E 'L'
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B8'         // E 'R'
					],
					[
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B9',    // F 'R'
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AB\uE0B2\uE0B3\uE0B5'     // F 'L'
					],
					[
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AC\uE0B2\uE0B3\uE0B5\uE0B9', // F# LRimport QtQuick.Controls 2.15

						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AC\uE0B2\uE0B3\uE0B5',       // F# L
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B6'        // F# R
					],
					'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5', '\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B7', '\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3', // A
					'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2', // Bb
					[
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B3', // B
						'\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B4'
					],
					'\uE0A3\uE0A6\uE0A7\uE0A9',       // C
					'\uE0A3\uE0A6\uE0A7\uE0A9\uE0AA',  // C#
					'\uE0A3\uE0A6\uE0A7', // D
					[
						'\uE0A3\uE0A6\uE0A7\uE0B1', // Eb
						'\uE0A3\uE0A6\uE0A7\uE0A8', // Eb
						'\uE0A3\uE0A6\uE0B2'        // Eb
					],
					'\uE0A3\uE0A6',  // E
					'\uE0A3',  // F
					[
						'\uE0A6',                 // F#
						'\uE0A3\uE0B0\uE0B1'
					],
					'',   // G
					'\uE0A5', // G#
					'\uE0A4',
					'\uE0A2\uE0A4',
					[     // B
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0AD\uE0B2\uE0B3\uE0B5\uE0B9', // LR 
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0AD\uE0B2\uE0B3\uE0B5',       // L
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B8'        // R
					],
					// 2nd Octave (C5-B5)
					[     // C
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B9',      // R
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0AB\uE0B2\uE0B3\uE0B5'       // L
					],
					[   // C#
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0AC\uE0B2\uE0B3\uE0B5',         // L
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0AC\uE0B2\uE0B3\uE0B5\uE0B9',   // LR
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B6'          // R
					],
					'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5',
					'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3\uE0B5\uE0B7', // D#
					'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B3',
					'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2',
					[     // F#
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B3',
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0B2\uE0B4'
					],
					'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9', // G
					'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A9\uE0AA', // G# 
					'\uE0A2\uE0A3\uE0A6\uE0A7',
					[  // A#
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0B1',
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0A8',
						'\uE0A2\uE0A3\uE0A6\uE0B2'
					],
					'\uE0A2\uE0A3\uE0A6',
					// 3nd Octave (C6-B6)
					'\uE0A2\uE0A3',
					'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B2\uE0B3',
					'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B2\uE0B7', // D
					[  // D#
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B2\uE0B4\uE0B7',
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B3\uE0B7'
					],
					'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B7',  // E
					'\uE0A2\uE0A3\uE0A7\uE0A9\uE0AA\uE0B7', // F
					[
						'\uE0A2\uE0A3\uE0A7\uE0B7',  // F#
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0B2\uE0B3\uE0B5\uE0B7'
					],
					[
						'\uE0A2\uE0A3\uE0A7\uE0B2\uE0B3\uE0B7',  // G
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B2\uE0B3\uE0B7'
					],
					[
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0AC\uE0B2\uE0B5',
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B2\uE0B5\uE0B6'
					],
					[
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0B9',
						'\uE0A2\uE0A3\uE0A7\uE0A9\uE0AB'
					],
					[
						'\uE0A2\uE0A3\uE0A5\uE0A7\uE0A9\uE0AA\uE0B7',
						'\uE0A2\uE0A3\uE0A5\uE0A7\uE0A9\uE0B6'
					],
					[
						'\uE0A2\uE0A3\uE0A5\uE0A6\uE0A7\uE0B2\uE0B3',
						'\uE0A2\uE0A3\uE0A6\uE0A7\uE0B2\uE0B3\uE0B6'
					],
					[
						'\uE0A2\uE0A3\uE0A5\uE0A6\uE0B2\uE0B6',
						'\uE0A2\uE0A3\uE0A5\uE0A6\uE0AC\uE0B2'
					],
				];
				this.allKeysPressed = '\uE0A0\uE0A2\uE0A3\uE0A4\uE0A5\uE0A6\uE0A7\uE0A8\uE0A9\uE0AA\uE0AB\uE0AC\uE0AD\uE0AE\uE0AF\uE0B0\uE0B1\uE0B2\uE0B3\uE0B4\uE0B5\uE0B6\uE0B7\uE0B8\uE0B9\uE0BA';
				if (instrument === 'wind.reed.clarinet.d' || instrument === 'd-clarinet') {
					this.transpose = 1;
				} else if (instrument === 'wind.reed.clarinet.bflat' || instrument === 'bb-clarinet') {
					this.transpose = 5;
				} else if (instrument === 'wind.reed.clarinet.basset' || instrument === 'basset-clarinet') {
					this.transpose = 1;
					this.base += '\uE0A1';
				} else if (instrument === 'wind.reed.clarinet.alto' || instrument === 'alto-clarinet') {
					this.transpose = 6;
				} else if (instrument === 'wind.reed.clarinet.bass' || instrument === 'bb-bass-clarinet') {
					this.transpose = 5;
					this.base += '\uE0A1';
				}
			} else if (instrument === 'wind.reed.oboe' || instrument === 'oboe') {
				this.instrument = 'oboe'; // Default: Oboe
				this.range = {
					minPitch: 58, // A#3
					maxPitch: 97, // C#7
				};
				this.base = '\uE140';
				this.mapping = [
					// 1st Octave (A#3-B4)
					'\uE143\uE147\uE149\uE14E\uE151\uE153\uE155\uE157','','\uE143\uE147\uE149\uE151\uE153\uE155\uE157','','','','','','','','','','','',
					// 2nd Octave (C5-B5)
					'','','','','','','','','','','','',
					// 3nd Octave (C6-C#7)
					'','','','','','','','','','','','',
				];
				this.allKeysPressed = '\uE140\uE141\uE142\uE143\uE144\uE145\uE146\uE147\uE148\uE149\uE14A\uE14B\uE14C\uE14D\uE14E\uE14F\uE150\uE151\uE152\uE153\uE154\uE155\uE156\uE157\uE158\uE159';
			} else if (instrument === 'wind.reed.bassoon' || instrument === 'bassoon') {
				this.instrument = 'bassoon';// Default: Bassoon
				this.range = {
					minPitch: 34, // A#1
					maxPitch: 77, // F5
				};
				this.base = '\uE1E0\uE1E1';
				this.mapping = [
					// 1st Octave (A#1-B2)
					'\uE1F8\uE1F9\uE1FA\uE1FB\uE1E3\uE1E5\uE1E6\uE1E7\uE1FD\uE1EB\uE1EC\uE1ED\uE1EF\uE1F0','','','','','','','','','','','','','',
					// 2nd Octave (C3-B3)
					'','','','','','','','','','','','',
					// 3nd Octave (C4-B4)
					'\uE1E3\uE1E5\uE1E6\uE1E7\uE1EC','','','','','','','','','','','',
					// 4th Octave (C5-F5)
					'','','','','','','','','','','','',
				];
				this.allKeysPressed = '\uE1E0\uE1E1\uE1F3\uE1F4\uE1F5\uE1F6\uE1F7\uE1F8\uE1F9\uE1FA\uE1FB\uE1E2\uE1E3\uE1E4\uE1E5\uE1E6\uE1E7\uE1E8\uE1E9\uE1FC\uE1FD\uE1FE\uE1FF\uE1EA\uE1EB\uE1EC\uE1ED\uE1EE\uE1EF\uE1F0\uE1F1\uE1F2';
			} else if (instrument === 'wind.reed.saxophone' || instrument === 'wind.reed.saxophone.soprano' || instrument === 'wind.reed.saxophone.alto' 
				|| instrument === 'wind.reed.saxophone.tenor' || instrument === 'wind.reed.saxophone.baritone'
                || instrument === 'soprano-saxophone' || instrument === 'alto-saxophone' || instrument === 'tenor-saxophone'  || instrument === 'baritone-saxophone') {
				this.instrument = 'soprano-saxophone'; // Default: Soprano Saxophone in Bb
				this.range = {
					minPitch: 55, // A3 (written)
					maxPitch: 108, // D8
				};
				this.base = '\uE280';
				this.mapping = [
					// 1st Octave (A3-B4)
					'\uE299\uE284\uE286\uE287\uE293\uE294\uE296\uE298','\uE284\uE286\uE287\uE28E\uE293\uE294\uE296\uE298','\uE284\uE286\uE287\uE28D\uE293\uE294\uE296\uE298','\uE284\uE286\uE287\uE293\uE294\uE296\uE298','\uE284\uE286\uE287\uE28C\uE293\uE294\uE296\uE298','\uE284\uE286\uE287\uE293\uE294\uE296','\uE284\uE286\uE287\uE293\uE294\uE296\uE297','\uE284\uE286\uE287\uE293\uE294','\uE284\uE286\uE287\uE293','\uE284\uE286\uE287\uE294','\uE284\uE286\uE287','\uE284\uE286\uE287\uE28B','\uE284\uE286','\uE284\uE285','\uE284',
					// 2nd Octave (C5-B5)
					'\uE286','','\uE282\uE284\uE286\uE287\uE293\uE294\uE296','\uE282\uE284\uE286\uE287\uE293\uE294\uE296\uE297','\uE282\uE284\uE286\uE287\uE293\uE294','\uE282\uE284\uE286\uE287\uE293','\uE282\uE284\uE286\uE287\uE294','\uE282\uE284\uE286\uE287','\uE282\uE284\uE286\uE287\uE28B','\uE282\uE284\uE286','\uE282\uE284\uE285','\uE282\uE284',
					// 3nd Octave (C6-B6)
					'\uE282\uE286','\uE282','\uE282\uE289','\uE282\uE288\uE289','\uE282\uE288\uE289\uE28F','\uE282\uE288\uE289\uE28A\uE28F','\uE282\uE283\uE286\uE28D','\uE282\uE284\uE287\uE296','\uE282\uE284\uE287','\uE282\uE286\uE287','\uE282\uE287\uE290','\uE282\uE289',
					// 4th Octave (C7-D8)
					'\uE282\uE288\uE289','\uE282\uE288\uE289\uE28F','\uE282\uE284\uE288','\uE282\uE283\uE286','\uE282\uE286\uE293\uE294','\uE282\uE284\uE287\uE293\uE296','','','','','','','','','',
				];
				this.allKeysPressed = '\uE280\uE281\uE282\uE299\uE283\uE284\uE285\uE286\uE287\uE288\uE289\uE28A\uE28B\uE28C\uE28D\uE28E\uE28F\uE290\uE291\uE292\uE293\uE294\uE295\uE296\uE297\uE298';
				if (instrument === 'wind.reed.saxophone.alto' || instrument === 'alto-saxophone') {
					this.transpose = 7;
				} else if (instrument === 'wind.reed.saxophone.tenor'|| instrument === 'tenor-saxophone') {
					this.transpose = 12;
				} else if (instrument === 'wind.reed.saxophone.baritone' || instrument === 'baritone-saxophone') {
					this.transpose = 19;
					this.base += '\uE281';
				}
			} else if (instrument === 'wind.flutes.recorder' || instrument === 'wind.flutes.recorder.soprano'
				|| instrument === 'wind.flutes.recorder.alto' || instrument === 'soprano-recorder' || instrument === 'descant-recorder' 
                || instrument === 'treble-recorder' || instrument === 'alto-recorder') {
				this.instrument = 'soprano-recorder'; // Default: Soprano Recorder (Baroque/English)
				this.range = {
					minPitch: 72, // C4 (written)
					maxPitch: 105, // A6
				};
				this.base = '\uE320';
				this.mapping = [
					// 1st Octave (C4-B4)
					'\uE321\uE322\uE323\uE324\uE325\uE326\uE327\uE328\uE329\uE32A','\uE321\uE322\uE323\uE324\uE325\uE326\uE327\uE328\uE329','\uE321\uE322\uE323\uE324\uE325\uE326\uE327\uE328','\uE321\uE322\uE323\uE324\uE325\uE326\uE327','\uE321\uE322\uE323\uE324\uE325\uE326','\uE321\uE322\uE323\uE324\uE325\uE327\uE328\uE329\uE32A','\uE321\uE322\uE323\uE324\uE326\uE327\uE328','\uE321\uE322\uE323\uE324','\uE321\uE322\uE323\uE325\uE326\uE327','\uE321\uE322\uE323','\uE321\uE322\uE324\uE325','\uE321\uE322',
					// 2nd Octave (C5-B5)
					'\uE321\uE323','\uE322\uE323','\uE323','\uE323\uE324\uE325\uE326\uE327\uE328','\uE32C\uE322\uE323\uE324\uE325\uE326','\uE32C\uE322\uE323\uE324\uE325\uE327\uE328','\uE32C\uE322\uE323\uE324\uE326','\uE32C\uE322\uE323\uE324','\uE32C\uE322\uE323\uE325','\uE32C\uE322\uE323','\uE32C\uE322\uE323\uE326\uE327\uE328','\uE32C\uE322\uE323\uE325\uE326',
					// 3nd Octave (C6-A6)
					'\uE32C\uE322\uE325\uE326','\uE32C\uE322\uE324\uE325\uE327\uE328\uE32B','\uE32C\uE322\uE324\uE325\uE327\uE328','\uE32C\uE323\uE324\uE326\uE327\uE328','\uE32C\uE323\uE324\uE326\uE327\uE328\uE32B','\uE32C\uE322\uE323\uE325\uE326\uE32B','\uE32C\uE322\uE323\uE325\uE326','\uE32C\uE322\uE325','\uE32C\uE322\uE324\uE327\uE328\uE329\uE32A\uE32B','\uE32C\uE322\uE324\uE326\uE327\uE328',
				];
				this.allKeysPressed = '\uE320\uE321\uE322\uE323\uE324\uE325\uE326\uE327\uE328\uE329\uE32A\uE32B';
				if (instrument === 'wind.flutes.recorder.alto' || instrument === 'alto-recorder') {
					this.transpose = 7;
				}
			} else if (instrument === 'wind.flutes.whistle.tin.d' || instrument === 'wind.flutes.whistle.tin.common'
				|| instrument === 'wind.flutes.whistle.low.d' || instrument === 'wind.flutes.whistle.low.f' || instrument === 'wind.flutes.whistle.low.g'
				|| instrument === 'wind.flutes.whistle.tin.bflat' || instrument === 'wind.flutes.whistle.tin'|| instrument === 'wind.flutes.whistle.tin.c'
				|| instrument === 'wind.flutes.whistle.tin.eflat' || instrument === 'wind.flutes.whistle.tin.f'|| instrument === 'wind.flutes.whistle.tin.g'
                || instrument === 'd-tin-whistle' || instrument === 'c-tin-whistle' || instrument === 'bflat-tin-whistle') {
				this.instrument = 'd-tin-whistle'; // Default: Tin Whistle
				this.range = {
					minPitch: 74, // D4 (written)
					maxPitch: 104, // G#6
				};
				this.base = '\uE3C0\uE3C3\uE3C6';
				this.mapping = [
					// 1st Octave (D4-B4)
					'\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6','\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3E6','\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5','\uE3CF\uE3D1\uE3D2\uE3D3\uE3E5','\uE3CF\uE3D1\uE3D2\uE3D3','\uE3CF\uE3D1\uE3D2','\uE3CF\uE3D1\uE3E2','\uE3CF\uE3D1','\uE3CF\uE3E1','\uE3CF',
					// 2nd Octave (C5-B5)
					'\uE3D1\uE3D2','','\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE43D','\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3E6\uE43D','\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE43D','\uE3CF\uE3D1\uE3D2\uE3D3\uE3E5\uE43D','\uE3CF\uE3D1\uE3D2\uE3D3\uE43D','\uE3CF\uE3D1\uE3D2\uE43D','\uE3CF\uE3D1\uE3E2\uE43D','\uE3CF\uE3D1\uE43D','\uE3CF\uE3E1\uE43D','\uE3CF\uE43D',
					// 3nd Octave (C6-G#6)
					'\uE3DF\uE43D','\uE3D1\uE3D2\uE3D3\uE43D','\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE43E','\uE3CF\uE3D1\uE3D3\uE3D6\uE43E','\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE43E','\uE3CF\uE3D1\uE3D2\uE3D3\uE3E5\uE3D6\uE43E','\uE3CF\uE3D1\uE3D2\uE3D3\uE3D6\uE43E','\uE3CF\uE3D1\uE3D2\uE3D6\uE43E','\uE3CF\uE3D1\uE3E2\uE3D6\uE43E',
				];
				this.allKeysPressed = '\uE3C0\uE3C3\uE3C6\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE43E';
				if (instrument === 'wind.flutes.whistle.low.d') {
					this.transpose = 12;
				} else if (instrument === 'wind.flutes.whistle.low.f') {
					this.transpose = 9;
				} else if (instrument === 'wind.flutes.whistle.low.g') {
					this.transpose = 7;
				} else if (instrument === 'wind.flutes.whistle.tin.bflat' || instrument === 'bflat-tin-whistle') {
					this.transpose = 4;
				} else if (instrument === 'wind.flutes.whistle.tin' || instrument === 'wind.flutes.whistle.tin.c' || instrument === 'c-tin-whistle') {
					this.transpose = 2;
				} else if (instrument === 'wind.flutes.whistle.tin.eflat') {
					this.transpose = -1;
				} else if (instrument === 'wind.flutes.whistle.tin.f') {
					this.transpose = -3;
				} else if (instrument === 'wind.flutes.whistle.tin.g') {
					this.transpose = -5;
				}
			} else if (instrument === 'wind.reed.xaphoon'
				|| instrument === 'wind.reed.xaphoon.g' || instrument === 'wind.reed.xaphoon.bflat' || instrument === 'wind.reed.xaphoon.d'
                || instrument === 'xaphoon' || instrument === 'g-xaphoon' || instrument === 'bb-xaphoon' || instrument === 'd-xaphoon') {
				this.instrument = 'xaphoon'; // Default: Xaphoon in C
				this.range = {
					minPitch: 59, // B3 (written)
					maxPitch: 84, // C6
				};
				this.base = '\uE3C0\uE3C1\uE3C2\uE3C3\uE3C6\uE3C7';
				this.mapping = [
					// 1st Octave (B3-B4)
					'\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE3D7','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE3D7','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE3E7','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D7','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D5\uE3D6\uE3D7','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE427','\uE3CD\uE3CE\uE3CF\uE3D1\uE3D3\uE3D5\uE3D6','\uE3CD\uE3CE\uE3CF\uE3D1\uE427','\uE3CD\uE3CE\uE3CF\uE427','\uE3CD\uE3CE\uE3D1\uE3D2\uE3D3\uE427',
					// 2nd Octave (C5-C6)
					'\uE3CD\uE3CE\uE427','\uE3CD\uE3CF\uE3D1\uE3D2\uE427','\uE3CD\uE427','\uE3CE\uE3CF\uE3D1\uE3D2\uE427','\uE3CE\uE427','\uE427','\uE427','\uE43F\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE3D7','\uE43F\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE3E7','\uE43F\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6','\uE43F\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D7','\uE43F\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3','\uE43F\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE427',
				];
				this.allKeysPressed = '\uE3C0\uE3C1\uE3C2\uE3C3\uE3C6\uE3C7\uE43F\uE3CD\uE3CE\uE3CF\uE3D1\uE3D2\uE3D3\uE3D5\uE3D6\uE3D7';
				if (instrument === 'wind.reed.xaphoon.g' || instrument === 'g-xaphoon') {
					this.transpose = 5;
				} else if (instrument === 'wind.reed.xaphoon.bflat' || instrument === 'bb-xaphoon') {
					this.transpose = 2;
				} else if (instrument === 'wind.reed.xaphoon.d' || instrument === 'd-xaphoon') {
					this.transpose = -2;
				}
			
            /////////////////////////////
            /// TRUMPETS + SAXHORNS 
            ///////////////////////////// 
             
             } else if (instrument === 'brass.trumpet' || instrument === 'bb-trumpet' || instrument === 'c-trumpet'
               || instrument === 'eb-trumpet' || instrument === 'd-trumpet' || instrument === 'pocket-trumpet'
               || instrument === 'bb-cornet' || instrument === 'eb-cornet' || instrument === 'flugelhorn'
               || instrument === 'brass.trumpet.bflat' || instrument === 'brass.trumpet.c' || instrument === 'brass.trumpet.d'
               || instrument === 'brass.trumpet.pocket' || instrument === 'brass.cornet' || instrument === 'brass.cornet.soprano'
               || instrument === 'brass.flugelhorn' || instrument === 'brass.alto-horn' || instrument === 'eb-alto-horn' || instrument === 'baritone-horn'
               || instrument === 'brass.baritone-horn' || instrument === 'baritone-horn-treble' || instrument === 'eb-bass-trumpet') {
                this.instrument = 'c-trumpet';
                this.range = { 
                    minPitch: 54, 
                    maxPitch: 84  
                };
                this.base = '\uE440'; 

                // Define the basic valve symbols (1st, 2nd, 3rd)
                var f = {
                    0: '',
                    1: '\uE441', // 1st valve
                    2: '\uE442', // 2nd valve
                    3: '\uE443'  // 3rd valve
                };
                              
                // Create combinations 
                f[12]  = f[1] + f[2];
                f[13]  = f[1] + f[3];
                f[23]  = f[2] + f[3];
                f[123] = f[1] + f[2] + f[3];

                this.mapping = [
                    f[123], // F#3 (54)
                    f[13],  // G3  (55)
                    f[23],  // G#3 (56)
                    f[12],   // A3  (57)
                    f[1],   // A#3 (58)
                    f[2],   // B3  (59)

                    // Octave 4 (C4 to B4) 
                    f[0],   // C4  (60) 
                    f[123],   // C#4 (61)
                    f[13],   // D4  (62)
                    f[23],  // D#4 (63) 
                    f[12],  // E4  (64) 
                    f[1],  // F4  (65) 
                    f[2], // F#4 (66)
                    f[0],  // G4  (67) 
                    f[23],  // G#4 (68)
                    f[12],   // A4  (69) 
                    f[1],   // A#4 (70)
                    f[2],   // B4  (71) 

                    // Octave 5 (C5 to B5) 
                    f[0],   // C5  (72) 
                    f[12],   // C#5 (73)
                    f[1],   // D5  (74)
                    f[2],  // D#5 (75) 
                    f[0],  // E5  (76)
                    f[1],  // F5  (77) 
                    f[2], // F#5 (78)
                    f[0],  // G5  (79) 
                    f[23],  // G#5 (80)
                    f[12],   // A5  (81) 
                    f[1],   // A#5 (82)
                    f[2],   // B5  (83) 

                    // Octave 6 (C6 and above)
                    f[0]    // C6  (84) 
                    // Notes above this (C#6, D6) are possible but players capable of playing in this range certainly do not need a fingering diagram
                ];
                if (instrument === 'bb-trumpet'|| instrument === 'bb-cornet' || instrument === 'pocket-trumpet' || instrument === 'flugelhorn'
                    || instrument === 'brass.trumpet.bflat' || instrument === 'brass.trumpet.pocket' || instrument === 'brass.cornet' || instrument === 'brass.flugelhorn') {
					this.transpose = 2;
                    }  
                if (instrument === 'eb-trumpet' || instrument === 'eb-cornet' || instrument === 'brass.trumpet' || instrument === 'brass.cornet.soprano'){
                        this.transpose = -3;
                    }
                if (instrument === 'd-trumpet' || instrument === 'brass.trumpet.d'){
                        this.transpose = -2;
                    }   
                if (instrument === 'brass.alto-horn' || instrument === 'eb-alto-horn' || instrument === 'eb-bass-trumpet'){
                        this.transpose = 9;
                    }        
                if (instrument === 'baritone-horn-treble'){
                        this.transpose = 14;
                    }  
                          
            ///////////////////////////
            /// TROMBONE
            ///////////////////////////           
			
                }  else if (instrument === 'brass.trombone' || instrument === 'brass.trombone.tenor' 
                    || instrument === 'tenor-trombone' || instrument === 'trombone') {
                    this.instrument = 'trombone';
                    this.range = { 
                        minPitch: 40, // Written E2 
                        maxPitch: 72  // Written C5 
                    };
                    this.base = ''; 
  

                    // Define the position symbols. we use numbers in circles
                    var p = {
                        1: '\u2460', // 1
                        2: '\u2461', // 2
                        3: '\u2462', // 3
                        4: '\u2463', // 4
                        5: '\u2464', // 5
                        6: '\u2465', // 6
                        7: '\u2466'  // 7
                    };

                    // mapping from https://norlanbewley.com/bewleymusic/trombone-slide-position-chart/
                    // The mapping array for written pitches from 40 (E2) to 72 (C5)
                    this.mapping = [
                        // Octave 2 (E2 to B2) - Trigger/valve notes are not included in this basic mapping
                        p[7], // E2  (40)  
                        p[6], // F2  (41)
                        p[5], // F#2 (42) 
                        p[4], // G2  (43)
                        p[3], // G#2 (44)
                        p[2], // A2  (45)
                        p[1], // A#2 (46)
                        p[7], // B2  (47)

                        // Octave 3 (C3 to B3) - Standard Staff Notes
                        p[6], // C3  (48) 
                        p[5], // C#3 (49)
                        p[4], // D3  (50)
                        p[3], // D#3 (51) 
                        p[2]+"\n"+p[7], // E3  (52)
                        p[1]+"\n"+p[6], // F3  (53)
                        p[5], // F#3 (54)
                        p[4], // G3  (55)
                        p[3]+"\n"+p[7], // G#3 (56) 
                        p[2]+"\n"+p[6], // A3  (57)
                        p[1]+"\n"+p[5], // A#3 (58) 
                        p[4]+"\n"+p[7], // B3  (59) 

                        // Octave 4 (C4 to C5) - Upper Staff
                        p[3]+"\n"+p[6], // C4  (60) 
                        p[2]+"\n"+p[5], // C#4 (61) 
                        p[1]+"\n"+p[4]+"\n"+p[7], // D4  (62) 
                        p[3]+"\n"+p[6], // D#4 (63) 
                        p[2]+"\n"+p[5]+"\n"+p[7], // E4  (64) 
                        p[1]+"\n"+p[4]+"\n"+p[6], // F4  (65) 
                        p[3]+"\n"+p[5]+"\n"+p[7], // F#4 (66) 
                        p[2]+"\n"+p[4]+"\n"+p[6], // G4  (67) 
                        p[3]+"\n"+p[5]+"\n"+p[7], // G#4 (68) 
                        p[2]+"\n"+p[4]+"\n"+p[6], // A4  (69) 
                        p[1]+"\n"+p[3]+"\n"+p[5], // A#4 (70) 
                        p[2]+"\n"+p[4]+"\n"+p[6], // B4  (71) 
                        p[1]+"\n"+p[3]+"\n"+p[5]  // C5  (72) 
                    ];
                    
                                
            ////////////////////    
            /// HORN F/Bb
            ////////////////////
                
			} else if (instrument === 'brass.french-horn' || instrument === 'horn') {
				this.instrument = 'horn'; 
				this.range = {
					minPitch: 41,
					maxPitch: 69,
				};
                
                this.base = '\uE446';
                
                var f = { 0: '', 1: '\uE447', 2: '\uE448', 3: '\uE449', 4: '', 5: '\uE441', 6: '\uE442', 7: '\uE443', 8: '\uE445' }; 
                f[12]   = f[1]+f[2];
                f[13]   = f[1]+f[3];
				f[23]   = f[2]+f[3];
                f[123]  = f[1]+f[2]+f[3];
                f[568]   = f[5]+f[6]+f[8];
                f[578]   = f[5]+f[7]+f[8];
                f[678]   = f[6]+f[7]+f[8];
                f[5678]  = f[5]+f[6]+f[7]+f[8];
                f[78]    = f[7]+f[8];
                f[68]    = f[6]+f[8];
                f[58]   = f[5]+f[8];
              
               
               
                this.mapping = [
                    f[13]+f[8],        // C (41)
                    f[23]+f[5678],  // C#  (42)
                    f[12]+f[578],   // D (43)
                    f[1]+f[678],   // D# (44)
                    f[2]+f[568],   // E (45)
                    f[0]+f[58],     // F (46)
                    f[123]+f[68],     // F# (47)
                    f[13]+f[8],          // G (48)
                    f[23]+f[678], // G# (49)
                    f[12]+f[568],  // A (50)
                    f[1]+f[58],     // A# (51)
                    f[2]+f[68],     //  B (52)
                    f[8],     // C (53)
                    f[23]+f[568],    // C# (54)
                    f[12]+f[58],     // D  (55)
                    f[1]+f[68],     // D# (56)
                    f[2]+f[8],    // E  (57)
                    f[58],     // F (58)
                    f[12]+f[68],    // F# (59)
                    f[1]+f[8],     // G  (60)
                    f[23]+f[678],    // G# (61)
                    f[12]+f[568],     // A  (62)
                    f[1]+f[58],     // A# (63)
                    f[2]+f[68],    // B (64)
                    f[8],         // C (65)
                    f[23]+f[68],     // C# (66)
                    f[12]+f[8],    // D  (67)
                    f[1]+f[68],     // D# (68)
                    f[2]+f[8],    // E  (69)
                ];
                
                
              
                
            ////////////////////    
            /// EUPHONIUM 
            ////////////////////
            
             } else if (instrument === 'brass.euphonium' || instrument === 'euphonium' || instrument === 'euphonium-treble'){
                this.instrument = 'euphonium';
                this.range = { 
                    minPitch: 40, 
                    maxPitch: 70  
                };
                this.base = '\uE444';     
                var f = { 0: '', 1: '\uE441', 2: '\uE442', 3: '\uE443', 4: '\uE445'};
                f[12]   = f[1]+f[2];
                f[13]   = f[1]+f[3];
				f[23]   = f[2]+f[3];
				f[24]   = f[2]+f[4];
				f[124]  = f[1]+f[2]+f[4];
				f[134]  = f[1]+f[3]+f[4];
				f[234]  = f[2]+f[3]+f[4];
				f[1234] = f[1]+f[2]+f[3]+f[4];
                
                this.mapping = [
                    f[24],    // E2  (40)
                    f[13],   // F2  (41)
                    f[23],  // F#2 (42)
                    f[12],   // G2  (43)
                    f[1],   // G#2 (44)
                    f[2],   // A2  (45)
                    f[0],    // A#2 (46)
                    f[24],    // B2  (47)

                    // Octave 3 (C3 to B3)
                    f[13],    // C3  (48)
                    f[23],  // C#3 (49)
                    f[12],   // D3  (50)
                    f[1],   // D#3 (51)
                    f[2],   // E3  (52)
                    f[0],    // F3  (53)
                    f[23],    // F#3 (54)
                    f[12],    // G3  (55)
                    f[1],   // G#3 (56)
                    f[2],   // A3  (57)
                    f[0],    // A#3 (58)
                    f[12],    // B3  (59)

                    // Octave 4 (C4 to B4)
                    f[1],    // C4  (60)
                    f[2],  // C#4 (61)
                    f[0],   // D4  (62)
                    f[1],   // D#4 (63)
                    f[2],   // E4  (64)
                    f[0],    // F4  (65)
                    f[23],    // F#4 (66)
                    f[12],    // G4  (67)
                    f[1],   // G#4 (68)
                    f[2],   // A4  (69)
                    f[0]    // A#4 (70)
                    ];
           
         
                
            ////////////////    
            /// TUBA
            ////////////////
            
                
			} else if (instrument === 'brass.tuba' || instrument === 'tuba') {
				this.instrument = 'tuba'; // Default: Tuba
				this.range = {
					minPitch: 24,
					maxPitch: 65,
				};
				this.base = '\uE3C0';
				var f = { 0: '', 1: '\uE3D1', 2: '\uE3D2', 3: '\uE3D3', 4: '\uE3D5'};

				f[12]   = f[1]+f[2];
				f[23]   = f[2]+f[3];
				f[24]   = f[2]+f[4];
				f[124]  = f[1]+f[2]+f[4];
				f[134]  = f[1]+f[3]+f[4];
				f[234]  = f[2]+f[3]+f[4];
				f[1234] = f[1]+f[2]+f[3]+f[4];

				this.mapping = [
					// 1st Octave (C1-B1)
					f[1234], f[134], f[234], f[124], f[24], f[4], f[23], f[12], f[1], f[2], f[0], f[24], 
					// 2nd Octave (C2-B2)
					f[4], f[23], f[12], f[1], f[2], f[0], f[23], f[12], f[1], f[2], f[0], f[12], 
					// 3rd Octave (C3-B3)
					f[4], f[23], f[12], f[1], f[2], f[0], f[23], f[12], f[1], f[2], f[0], f[12], 
					// 4th Octave (C4-F4)
					f[4], f[23], f[12], f[1], f[2], f[0]
				];
			}
		}
		
		this._getInstrumentId = function() {
			var part = this.part;
			var instrumentId = part.instrumentId;
			if (part && !instrumentId && part.midiProgram && midiMapping.has(midiMapping)) {
				instrumentId = midiMapping[part.midiProgram];
			}
			if (instrumentId) {
				this._populate(instrumentId);
			}
			return instrumentId;
		}

		this.getPitchText = function(pitch) {
			var txt = null;
			if (pitch == null || pitch < this.range.minPitch - this.transpose) {
				console.log('Skipped note as it was too low. Pitch: ' + pitch);
				return txt;
			} else if (pitch > this.range.maxPitch - this.transpose) {
				console.log('Skipped note as it was too high. Pitch: ' + pitch);
				return txt;
			}
			var index = pitch + this.transpose - this.range.minPitch;
			var mapping = this.mapping[index];
			if (mapping == null) {
				console.log('Note fingering not found. Index: ' + index);
				return txt;
			} else if (Array.isArray(mapping)) {
				// In case alternate fingering, we will consider the first one for now
				mapping = mapping[0];
			}
			txt = this.base + mapping;
			return txt;
		}

		this.instrumentId = this._getInstrumentId();
       
	}

	property variant midiMapping : {
		56: 'brass.trumpet',
		59: 'brass.trumpet',
		57: 'brass.trombone',
		58: 'brass.tuba',
		60: 'brass.french-horn',
		64: 'wind.reed.saxophone.soprano',
		65: 'wind.reed.saxophone.alto',
		66: 'wind.reed.saxophone.tenor',
		67: 'wind.reed.saxophone.baritone',
		68: 'wind.reed.oboe',
		69: 'wind.reed.english-horn',
		70: 'wind.reed.bassoon',
		71: 'wind.reed.clarinet',
		72: 'wind.flutes.flute.piccolo',
		73: 'wind.flutes.flute',
		74: 'wind.flutes.recorder'
	};
	property variant offsetY : 4; // When fingering element not available
	property variant offsetX : 0.5; // When fingering element not available
	property variant fontSize : 42;

    
    MessageDialog {
        id: fontMissingDialog
        visible: false
        title: "Missing Fiati music font!"
		text: "The Fiati music font is not installed on your device.\n\n You can download the font from here:\n https://github.com/eduardomourar/fiati/releases\n The Zip file contains the font file you need to install on your device.\n You will also need to restart MuseScore for it to recognize the new font."
        onAccepted: {
          close();
        }
    }

    

	MessageDialog {
		id: versionDialog
		visible: false
		title: "Unsupported MuseScore version"
		text: "This MuseScore version is not supported.\n\n In order to run this plugin, you need MuseScore version 3.2.1 or higher."
		onAccepted: {
			quit()
		}
	}

	MessageDialog {
		id: nothingProcessed
		visible: false
		title: "No valid score found"
		text: "The instruments in this project are not supported or not yet fully implemented. Nothing was changed."
		onAccepted: {
			quit()
		}
	}

	function changeElement(element, fingering) {
		element.text = fingering;
		element.fontFace = 'Fiati';
        element.fontSize = 42;
		// LEFT = 0, RIGHT = 1, HCENTER = 2, TOP = 0, BOTTOM = 4, VCENTER = 8, BASELINE = 16
		element.align = 2; // HCenter and top
		// Set text to below the staff
		element.placement = Placement.BELOW;
		// Turn on note relative placement
		element.autoplace = true;

		return element;
	}

   
    
 	function renderFingering() {
		var fingering = null;
		var startStaff;
		var endStaff;
		var endTick;
		var fullScore = false;
		var elementType;
		var supportFingeringElement = (mscoreVersion >= 30500);
		var staffChanged = 0;
		var staffFound = [];
        
                    
		if (supportFingeringElement) {
			elementType = Element.FINGERING;
		} else {
			// STAFF_TEXT element has some issues with autoplace, so you might want to use LYRICS
			elementType = Element.STAFF_TEXT;
		}
		// Find out range to apply to, either selection or full score
		var cursor = curScore.newCursor();
		cursor.rewind(1); // start of selection
		if (!cursor.segment) { // no selection
			fullScore = true;
			startStaff = 0; // start with 1st staff
			endStaff = curScore.nstaves - 1; // and end with last
			console.log('Full score staves ' + startStaff + ' - ' + endStaff);
		} else {
			startStaff = cursor.staffIdx;
			cursor.rewind(2); // Find end of selection
			if (cursor.tick == 0) {
				endTick = curScore.lastSegment.tick + 1;
			} else {
				endTick = cursor.tick;
			}
			endStaff = cursor.staffIdx;
			console.log('Selected staves ' + startStaff + ' - ' + endStaff + ' - End position: ' + endTick);
		}

		// Loop over the selection
		for (var staff = startStaff; staff <= endStaff; staff++) {
			// Check for supported instrument parts
			var part = curScore.parts[staff];
			fingering = new fingeringConstructor(part);
			staffFound.push(part.longName + ' (' + part.instrumentId + ')');
			if (fingering && fingering.instrument) {
				console.log('Staff ' + staff + ' instrument: ' + fingering.instrumentId);
				staffChanged += 1;
			} else {
				console.log('Skipped staff ' + staff);
				continue;
			}

			if (curScore.hasLyrics) {
				offsetY += 2   // try not to clash with any lyrics
			}
			cursor.voice = 0
			cursor.rewind(1); // beginning of selection
			cursor.staffIdx = staff;

			if (fullScore) { // no selection
				cursor.rewind(0); // beginning of score
			}

			while (cursor.segment && (fullScore || cursor.tick < endTick)) {
				if (cursor.element && cursor.element.type == Element.CHORD) {
					var graceChords = cursor.element.graceNotes;
					for (var j = 0; j < graceChords.length; j++) {
						// Iterate through all grace chords
						var notes = graceChords[j].notes;
						for (var i = 0; i < notes.length; i++) {
							var text = fingering.getPitchText(notes[i].pitch);
							if (text != null) {
								var el = newElement(elementType);
								if (supportFingeringElement) {
									notes[i].add(el);
								} else {
									cursor.add(el);
									var noteType = notes[i].noteType;
									var graceOffset = -2.5;
									if (noteType == NoteType.GRACE8_AFTER || noteType == NoteType.GRACE16_AFTER ||
										noteType == NoteType.GRACE32_AFTER) {
										graceOffset = -1 * graceOffset;
									}

									// There seems to be no way of knowing the exact horizontal position
									// of a grace note, so we have to guess.
									el.offsetX = offsetX + graceOffset * (graceChords.length - j);
									// el.offsetY = offsetY;
								}
								el.fontSize = fontSize * 0.7;
								changeElement(el, text);
							}
						}
					}

					var notes = cursor.element.notes;
					for (var i = 0; i < notes.length; i++) {
						var text = fingering.getPitchText(notes[i].pitch); // fingering.allKeysPressed; //
						if (text != null) {
							var el = newElement(elementType);
							if (supportFingeringElement) {
								notes[i].add(el);
							} else {
								cursor.add(el);
								el.offsetX = offsetX;
								// el.offsetY = offsetY;
							}
							el.fontSize = fontSize;
                            //TODO: improve the placing of element for different scenarios
							changeElement(el, text);
                          
                            // If the text is trombone position, force 12pt
                            //if (text >= '\u2460' && text <= '\u2466') {
                            if ((text >= '\u2460' && text <= '\u2466') || text.indexOf('T') !== -1) {
                                el.fontSize = 12;
                                el.fontFace = "FreeSerif";
                            }
                            
                            
						}
					}
				} // end if CHORD
				cursor.next();
			} // end while segment
		} // end for staff
		if (staffChanged == 0) {
			nothingProcessed.detailedText = "Found following instruments:\n"+staffFound.join('\n')+"\n\nSupported are only:\n";
			for (var i in midiMapping) {
				nothingProcessed.detailedText += midiMapping[i] + "\n";
			}
			nothingProcessed.open();
		}
	}

	onRun: {
         
         curScore.startCmd() 
    
		if (mscoreVersion < 30201) {
			versionDialog.open();
		//} else if (Qt.fontFamilies().indexOf('Fiati') < 0) {
        } else if (!Qt.fontFamilies().some(f => f.includes("Fiati"))) {
    		fontMissingDialog.open();
		} else {
			renderFingering();
        }
        
         curScore.endCmd()  

		quit();
	}
}
