﻿package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	internal class Particle2DListSorter extends ParticleListSorter {
		
		private static var _instance:Particle2DListSorter;
		public static function getInstance():Particle2DListSorter {
			if (!_instance) _instance = new Particle2DListSorter();
			return _instance;
		}
		
		public function Particle2DListSorter() {
			
		}
		
		override public function sort(particles:ParticleList):void {
			particles.head = mergeSort(particles.head);
		}
		
		private function mergeSort(node:ParticleNode):ParticleNode {
			if (!node) return null;
			
			var h:ParticleNode = node, p:ParticleNode, q:ParticleNode, e:ParticleNode, tail:ParticleNode;
			var insize:int = 1, nmerges:int, psize:int, qsize:int, i:int;
			
			while (true) {
				p = h;
				h = tail = null;
				nmerges = 0;
				
				while (p) {
					nmerges++;
					
					for (i = 0, psize = 0, q = p; i < insize; i++) {
						psize++;
						q = q.next;
						if (!q) break;
					}
					
					qsize = insize;
					
					while (psize > 0 || (qsize > 0 && q)) {
						if (psize == 0) {
							e = q; q = q.next; qsize--;
						} else if (qsize == 0 || !q) {
							e = p; p = p.next; psize--;
						} else if (Particle2D(p.particle).x - Particle2D(q.particle).x <= 0) {
							e = p; p = p.next; psize--;
						} else {
							e = q; q = q.next; qsize--;
						}
						
						if (tail) tail.next = e;
						else h = e;
						
						e.prev = tail;
						tail = e;
					}
					p = q;
				}
				
				node.prev = tail;
				tail.next = null;
				if (nmerges <= 1) {
					h.prev = null;
					return h;
					break;
				}
				insize <<= 1;
			}
			return null;
		}
	}
}