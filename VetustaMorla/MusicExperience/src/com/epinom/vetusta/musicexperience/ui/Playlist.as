﻿package com.epinom.vetusta.musicexperience.ui{	import caurina.transitions.Tweener;		import com.epinom.vetusta.musicexperience.data.DataModel;	import com.epinom.vetusta.musicexperience.events.EventComplex;		import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.events.MouseEvent;
		public class Playlist extends MovieClip	{		// Movieclips 		private var _playingTrackIndicator:MovieClip;		private var _playlistActivatorButton:SimpleButton;		private var _trackList:MovieClip;		private var _activityIndicator:MovieClip;				// Variables		private var _trackMovieClipList:Array;		private var _activeTrackMovieClip:MovieClip;		private var _isSongListVisible:Boolean		private var _indexOfCurrentTrack:uint;				public function Playlist()		{			super();			trace("Playlist->Playlist()");						// Apuntando movieclips de fichero swf a las variables de referencia de la clase			_playingTrackIndicator = playingTrackIndicator;			_playlistActivatorButton = activatorButton;			_trackList = trackList;			_activityIndicator = activityIndicator;						// Configurando visibilidad de objetos			_trackList.alpha = 0;			_trackList.visible = false;			_activityIndicator.visible = false;						// Inicializando propiedades			_isSongListVisible = false;			_trackMovieClipList = new Array();			for(var i:int = 0; i < DataModel.TOTAL_TRACKS_OF_THE_DISC; i++)			{				// Obteniendo movieclips que representan las canciones				var trackMovieClip:MovieClip = trackList["track_" + i] as MovieClip;								// Configurando detectores de eventos				(trackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onTrackClickHandler);				(trackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, onTrackMouseOverHandler);				(trackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT, onTrackMouseOutHandler);								// Adicionando movieclips a la lista				_trackMovieClipList.push(trackMovieClip);			}						// Configurando detectores de eventos			_playlistActivatorButton.addEventListener(MouseEvent.CLICK, changeTracklistVisibility);		}				private function changeTracklistVisibility(evt:MouseEvent = null):void		{			// Visibilizando lista de reproduccion, aunque puede que este con alpha = 0			_trackList.visible = true;						// Cambiando visibilidad de tracklist			if(_isSongListVisible) Tweener.addTween(_trackList, {alpha:0, time:.3, transition:"linear", onComplete:function():void {_trackList.visible = false;}}); 			else Tweener.addTween(_trackList, {alpha:1, time:.3, transition:"linear"});						// Actualizando variable de control de visibilidad			_isSongListVisible = !_isSongListVisible;		}				public function updateInterfaceForTrackSelected(index:uint):void 		{			// Si se ha seleccionado antes alguna cancion			if(_activeTrackMovieClip)			{				// Activando el movieclip para la anterior track seleccionada				_activeTrackMovieClip.gotoAndStop("off");				(_activeTrackMovieClip.btn as SimpleButton).enabled = true;				(_activeTrackMovieClip.btn as SimpleButton).useHandCursor = true;				(_activeTrackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onTrackClickHandler);				(_activeTrackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, onTrackMouseOverHandler);				(_activeTrackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT, onTrackMouseOutHandler);			}						// Obteniendo movieclip padre del boton clickado			var trackMovieClip:MovieClip = _trackMovieClipList[index];						// Desactivando el movieclip para la actual track seleccionada			trackMovieClip.gotoAndStop("active");			(trackMovieClip.btn as SimpleButton).enabled = false;			(trackMovieClip.btn as SimpleButton).useHandCursor = false;			(trackMovieClip.btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onTrackClickHandler);			(trackMovieClip.btn as SimpleButton).removeEventListener(MouseEvent.MOUSE_OVER, onTrackMouseOverHandler);			(trackMovieClip.btn as SimpleButton).removeEventListener(MouseEvent.MOUSE_OUT, onTrackMouseOutHandler);						// Actualizando el indicador de track en la barra			_playingTrackIndicator.gotoAndStop(trackMovieClip.name);						// Generando evento de cambio de cancion y embebiendo nombre de la cancion seleccionada por el usuario			var evt:EventComplex = new EventComplex(DataModel.USER_CHANGE_TRACK_EVENT);			evt.data = new Object();			evt.data.trackIndex = index;						// Actualizando indice de cancion actual			_indexOfCurrentTrack = index;			trace("Track selected index: ", _indexOfCurrentTrack);						// Despachando evento			trace("[Playlist] Evento USER_CHANGE_TRACK_EVENT despachado...");			dispatchEvent(evt);						// Actualizando track activa			_activeTrackMovieClip = trackMovieClip;		}				public function nextTrack():void 		{			trace("Current track index: ", _indexOfCurrentTrack);			var nextTrackIndex:uint = (_indexOfCurrentTrack == DataModel.TOTAL_TRACKS_OF_THE_DISC - 1) ? 0 : _indexOfCurrentTrack + 1;			trace("Next track index: ", nextTrackIndex);			updateInterfaceForTrackSelected(nextTrackIndex);		}				public function stopActivityIndicator():void {			_activityIndicator.visible = false;			trace("Deteniendo indicador de actividad mientras se carga la cancion seleccionada...");		}				private function onTrackClickHandler(evt:MouseEvent):void 		{			// Si se ha seleccionado antes alguna cancion			if(_activeTrackMovieClip)			{				// Activando el movieclip para la anterior track seleccionada				_activeTrackMovieClip.gotoAndStop("off");				(_activeTrackMovieClip.btn as SimpleButton).enabled = true;				(_activeTrackMovieClip.btn as SimpleButton).useHandCursor = true;				(_activeTrackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onTrackClickHandler);				(_activeTrackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.MOUSE_OVER, onTrackMouseOverHandler);				(_activeTrackMovieClip.btn as SimpleButton).addEventListener(MouseEvent.MOUSE_OUT, onTrackMouseOutHandler);			}						// Obteniendo movieclip padre del boton clickado			var trackMovieClip:MovieClip = (evt.target as SimpleButton).parent as MovieClip;							// Desactivando el movieclip para la actual track seleccionada			trackMovieClip.gotoAndStop("active");			(trackMovieClip.btn as SimpleButton).enabled = false;			(trackMovieClip.btn as SimpleButton).useHandCursor = false;			(trackMovieClip.btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onTrackClickHandler);			(trackMovieClip.btn as SimpleButton).removeEventListener(MouseEvent.MOUSE_OVER, onTrackMouseOverHandler);			(trackMovieClip.btn as SimpleButton).removeEventListener(MouseEvent.MOUSE_OUT, onTrackMouseOutHandler);						// Actualizando el indicador de track en la barra			_playingTrackIndicator.gotoAndStop(trackMovieClip.name);						// Obteniendo indice del sonido 			var trackInstanceName:String = trackMovieClip.name;			var index:int = trackInstanceName.lastIndexOf("_");			var trackIndexInDiscSelected:uint = uint(trackInstanceName.substr(index + 1));			trace("Track index: ", trackIndexInDiscSelected);						// Generando evento de cambio de cancion y embebiendo nombre de la cancion seleccionada por el usuario			var event:EventComplex = new EventComplex(DataModel.USER_CHANGE_TRACK_EVENT);			event.data = new Object();			event.data.trackIndex = trackIndexInDiscSelected;						// Actualizando indice de cancion actual			_indexOfCurrentTrack = trackIndexInDiscSelected;			trace("Track selected index: ", _indexOfCurrentTrack);						// Despachando evento			trace("[Playlist] Evento USER_CHANGE_TRACK_EVENT despachado...");			dispatchEvent(event);						// Activando indicador de actividad mientras se carga la cancion seleccionada por el usuario			_activityIndicator.visible = true;			trace("Activando indicador de actividad mientras se carga la cancion seleccionada...");						// Invisibilizando el tracklist			changeTracklistVisibility();						// Actualizando track activa			_activeTrackMovieClip = trackMovieClip;		}				private function onTrackMouseOverHandler(evt:MouseEvent):void 		{			// Obteniendo movieclip padre del boton clickado			var trackMovieClip:MovieClip = (evt.target as SimpleButton).parent as MovieClip;						// Pasando a estado de OVER			trackMovieClip.gotoAndStop("on");					}				private function onTrackMouseOutHandler(evt:MouseEvent):void 		{			// Obteniendo movieclip padre del boton clickado			var trackMovieClip:MovieClip = (evt.target as SimpleButton).parent as MovieClip;						// Pasando a estado de OVER			trackMovieClip.gotoAndStop("off");		}	}}