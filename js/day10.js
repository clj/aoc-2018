/* Generated by the Nim Compiler v0.19.2 */
/*   (c) 2018 Andreas Rumpf */

var framePtr = null;
var excHandler = 0;
var lastJSError = null;
if (typeof Int8Array === 'undefined') Int8Array = Array;
if (typeof Int16Array === 'undefined') Int16Array = Array;
if (typeof Int32Array === 'undefined') Int32Array = Array;
if (typeof Uint8Array === 'undefined') Uint8Array = Array;
if (typeof Uint16Array === 'undefined') Uint16Array = Array;
if (typeof Uint32Array === 'undefined') Uint32Array = Array;
if (typeof Float32Array === 'undefined') Float32Array = Array;
if (typeof Float64Array === 'undefined') Float64Array = Array;
var NTI198782 = {size: 0, kind: 18, base: null, node: null, finalizer: null};
var NTI198235 = {size: 0, kind: 18, base: null, node: null, finalizer: null};
var NTI198628 = {size: 0,kind: 24,base: null,node: null,finalizer: null};
var NTI160957 = {size: 0,kind: 24,base: null,node: null,finalizer: null};
var NTI160253 = {size: 0,kind: 24,base: null,node: null,finalizer: null};
var NTI104 = {size: 0,kind: 31,base: null,node: null,finalizer: null};
var NTI134015 = {size: 0,kind: 31,base: null,node: null,finalizer: null};
var NTI160234 = {size: 0, kind: 18, base: null, node: null, finalizer: null};
var NTI160231 = {size: 0,kind: 24,base: null,node: null,finalizer: null};
var NTI160228 = {size: 0, kind: 18, base: null, node: null, finalizer: null};
var NTI130 = {size: 0,kind: 1,base: null,node: null,finalizer: null};
var NTI124 = {size: 0,kind: 36,base: null,node: null,finalizer: null};
var NTI9287 = {size: 0,kind: 35,base: null,node: null,finalizer: null};
var NTI138 = {size: 0,kind: 28,base: null,node: null,finalizer: null};
var NTI160202 = {size: 0, kind: 14, base: null, node: null, finalizer: null};
var NTI160206 = {size: 0, kind: 18, base: null, node: null, finalizer: null};
var NTI160204 = {size: 0,kind: 22,base: null,node: null,finalizer: null};
var NTI160665 = {size: 0,kind: 24,base: null,node: null,finalizer: null};
var NNI160202 = {kind: 2, offset: 0, typ: null, name: null, len: 7, sons: {"0": {kind: 1, offset: 0, typ: NTI160202, name: "JNull", len: 0, sons: null}, 
"1": {kind: 1, offset: 1, typ: NTI160202, name: "JBool", len: 0, sons: null}, 
"2": {kind: 1, offset: 2, typ: NTI160202, name: "JInt", len: 0, sons: null}, 
"3": {kind: 1, offset: 3, typ: NTI160202, name: "JFloat", len: 0, sons: null}, 
"4": {kind: 1, offset: 4, typ: NTI160202, name: "JString", len: 0, sons: null}, 
"5": {kind: 1, offset: 5, typ: NTI160202, name: "JObject", len: 0, sons: null}, 
"6": {kind: 1, offset: 6, typ: NTI160202, name: "JArray", len: 0, sons: null}}};
NTI160202.node = NNI160202;
var NNI160234 = {kind: 2, len: 4, offset: 0, typ: null, name: null, sons: [{kind: 1, offset: "Field0", len: 0, typ: NTI134015, name: "Field0", sons: null}, 
{kind: 1, offset: "Field1", len: 0, typ: NTI104, name: "Field1", sons: null}, 
{kind: 1, offset: "Field2", len: 0, typ: NTI138, name: "Field2", sons: null}, 
{kind: 1, offset: "Field3", len: 0, typ: NTI160204, name: "Field3", sons: null}]};
NTI160234.node = NNI160234;
NTI160231.base = NTI160234;
var NNI160228 = {kind: 2, len: 4, offset: 0, typ: null, name: null, sons: [{kind: 1, offset: "data", len: 0, typ: NTI160231, name: "data", sons: null}, 
{kind: 1, offset: "counter", len: 0, typ: NTI104, name: "counter", sons: null}, 
{kind: 1, offset: "first", len: 0, typ: NTI104, name: "first", sons: null}, 
{kind: 1, offset: "last", len: 0, typ: NTI104, name: "last", sons: null}]};
NTI160228.node = NNI160228;
NTI160253.base = NTI160204;
var NNI160206 = {kind: 3, offset: "kind", len: 7, typ: NTI160202, name: "kind", sons: [[setConstr(4), {kind: 1, offset: "str", len: 0, typ: NTI138, name: "str", sons: null}], 
[setConstr(2), {kind: 1, offset: "num", len: 0, typ: NTI9287, name: "num", sons: null}], 
[setConstr(3), {kind: 1, offset: "fnum", len: 0, typ: NTI124, name: "fnum", sons: null}], 
[setConstr(1), {kind: 1, offset: "bval", len: 0, typ: NTI130, name: "bval", sons: null}], 
[setConstr(0), {kind: 2, len: 0, offset: 0, typ: null, name: null, sons: []}], 
[setConstr(5), {kind: 1, offset: "fields", len: 0, typ: NTI160228, name: "fields", sons: null}], 
[setConstr(6), {kind: 1, offset: "elems", len: 0, typ: NTI160253, name: "elems", sons: null}]]};
NTI160206.node = NNI160206;
NTI160204.base = NTI160206;
NTI160665.base = NTI160204;
NTI160957.base = NTI160204;
NTI198628.base = NTI124;
var NNI198235 = {kind: 2, len: 4, offset: 0, typ: null, name: null, sons: [{kind: 1, offset: "Field0", len: 0, typ: NTI124, name: "Field0", sons: null}, 
{kind: 1, offset: "Field1", len: 0, typ: NTI124, name: "Field1", sons: null}, 
{kind: 1, offset: "Field2", len: 0, typ: NTI124, name: "Field2", sons: null}, 
{kind: 1, offset: "Field3", len: 0, typ: NTI124, name: "Field3", sons: null}]};
NTI198235.node = NNI198235;
var NNI198782 = {kind: 2, len: 4, offset: 0, typ: null, name: null, sons: [{kind: 1, offset: "Field0", len: 0, typ: NTI124, name: "Field0", sons: null}, 
{kind: 1, offset: "Field1", len: 0, typ: NTI124, name: "Field1", sons: null}, 
{kind: 1, offset: "Field2", len: 0, typ: NTI124, name: "Field2", sons: null}, 
{kind: 1, offset: "Field3", len: 0, typ: NTI124, name: "Field3", sons: null}]};
NTI198782.node = NNI198782;

function cstrToNimstr(c_16242) {
		  var ln = c_16242.length;
  var result = new Array(ln);
  var r = 0;
  for (var i = 0; i < ln; ++i) {
    var ch = c_16242.charCodeAt(i);

    if (ch < 128) {
      result[r] = ch;
    }
    else {
      if (ch < 2048) {
        result[r] = (ch >> 6) | 192;
      }
      else {
        if (ch < 55296 || ch >= 57344) {
          result[r] = (ch >> 12) | 224;
        }
        else {
            ++i;
            ch = 65536 + (((ch & 1023) << 10) | (c_16242.charCodeAt(i) & 1023));
            result[r] = (ch >> 18) | 240;
            ++r;
            result[r] = ((ch >> 12) & 63) | 128;
        }
        ++r;
        result[r] = ((ch >> 6) & 63) | 128;
      }
      ++r;
      result[r] = (ch & 63) | 128;
    }
    ++r;
  }
  return result;
  

	
}

function toJSStr(s_16259) {
		  if (s_16259 === null) return "";
  var len = s_16259.length;
  var asciiPart = new Array(len);
  var fcc = String.fromCharCode;
  var nonAsciiPart = null;
  var nonAsciiOffset = 0;
  for (var i = 0; i < len; ++i) {
    if (nonAsciiPart !== null) {
      var offset = (i - nonAsciiOffset) * 2;
      var code = s_16259[i].toString(16);
      if (code.length == 1) {
        code = "0"+code;
      }
      nonAsciiPart[offset] = "%";
      nonAsciiPart[offset + 1] = code;
    }
    else if (s_16259[i] < 128)
      asciiPart[i] = fcc(s_16259[i]);
    else {
      asciiPart.length = i;
      nonAsciiOffset = i;
      nonAsciiPart = new Array((len - i) * 2);
      --i;
    }
  }
  asciiPart = asciiPart.join("");
  return (nonAsciiPart === null) ?
      asciiPart : asciiPart + decodeURIComponent(nonAsciiPart.join(""));
  

	
}

function setConstr() {
		    var result = {};
    for (var i = 0; i < arguments.length; ++i) {
      var x = arguments[i];
      if (typeof(x) == "object") {
        for (var j = x[0]; j <= x[1]; ++j) {
          result[j] = true;
        }
      } else {
        result[x] = true;
      }
    }
    return result;
  

	
}
var ConstSet1 = setConstr(17, 16, 4, 18, 27, 19, 23, 22, 21);

function nimCopy(dest_17230, src_17231, ti_17232) {
	var result_17655 = null;

		switch (ti_17232.kind) {
		case 21:
		case 22:
		case 23:
		case 5:
			if (!(is_fat_pointer_17201(ti_17232))) {
			result_17655 = src_17231;
			}
			else {
				result_17655 = [src_17231[0], src_17231[1]];
			}
			
			break;
		case 19:
			      if (dest_17230 === null || dest_17230 === undefined) {
        dest_17230 = {};
      }
      else {
        for (var key in dest_17230) { delete dest_17230[key]; }
      }
      for (var key in src_17231) { dest_17230[key] = src_17231[key]; }
      result_17655 = dest_17230;
    
			break;
		case 18:
		case 17:
			if (!((ti_17232.base == null))) {
			result_17655 = nimCopy(dest_17230, src_17231, ti_17232.base);
			}
			else {
			if ((ti_17232.kind == 17)) {
			result_17655 = (dest_17230 === null || dest_17230 === undefined) ? {m_type: ti_17232} : dest_17230;
			}
			else {
				result_17655 = (dest_17230 === null || dest_17230 === undefined) ? {} : dest_17230;
			}
			}
			nimCopyAux(result_17655, src_17231, ti_17232.node);
			break;
		case 24:
		case 4:
		case 27:
		case 16:
			      if (src_17231 === null) {
        result_17655 = null;
      }
      else {
        if (dest_17230 === null || dest_17230 === undefined) {
          dest_17230 = new Array(src_17231.length);
        }
        else {
          dest_17230.length = src_17231.length;
        }
        result_17655 = dest_17230;
        for (var i = 0; i < src_17231.length; ++i) {
          result_17655[i] = nimCopy(result_17655[i], src_17231[i], ti_17232.base);
        }
      }
    
			break;
		case 28:
			      if (src_17231 !== null) {
        result_17655 = src_17231.slice(0);
      }
    
			break;
		default: 
			result_17655 = src_17231;
			break;
		}

	return result_17655;

}

function eqStrings(a_16454, b_16455) {
		    if (a_16454 == b_16455) return true;
    if (a_16454 === null && b_16455.length == 0) return true;
    if (b_16455 === null && a_16454.length == 0) return true;
    if ((!a_16454) || (!b_16455)) return false;
    var alen = a_16454.length;
    if (alen != b_16455.length) return false;
    for (var i = 0; i < alen; ++i)
      if (a_16454[i] != b_16455[i]) return false;
    return true;
  

	
}

function nimMin(a_16940, b_16941) {
		var Tmp1;

	var result_16942 = 0;

	BeforeRet: do {
		if ((a_16940 <= b_16941)) {
		Tmp1 = a_16940;
		}
		else {
		Tmp1 = b_16941;
		}
		
		result_16942 = Tmp1;
		break BeforeRet;
	} while (false);

	return result_16942;

}

function nimMax(a_16958, b_16959) {
		var Tmp1;

	var result_16960 = 0;

	BeforeRet: do {
		if ((b_16959 <= a_16958)) {
		Tmp1 = a_16958;
		}
		else {
		Tmp1 = b_16959;
		}
		
		result_16960 = Tmp1;
		break BeforeRet;
	} while (false);

	return result_16960;

}
var nimvm_7173 = false;
var nim_program_result = 0;
var global_raise_hook_13418 = [null];
var local_raise_hook_13423 = [null];
var out_of_mem_hook_13426 = [null];
  if (!Math.trunc) {
    Math.trunc = function(v) {
      v = +v;
      if (!isFinite(v)) return v;

      return (v - v % 1)   ||   (v < 0 ? -0 : v === 0 ? v : 0);
    };
  }
var object_id_134246 = [0];

function get_var_type_180791(x_180793) {
	var result_180794 = 0;

	BeforeRet: do {
		result_180794 = 0;
		switch (toJSStr(cstrToNimstr(Object.prototype.toString.call(x_180793)))) {
		case "[object Array]":
			result_180794 = 6;
			break BeforeRet;
			break;
		case "[object Object]":
			result_180794 = 5;
			break BeforeRet;
			break;
		case "[object Number]":
			if ((x_180793 % 1.0000000000000000e+00 == 0.0)) {
			result_180794 = 2;
			break BeforeRet;
			}
			else {
				result_180794 = 3;
				break BeforeRet;
			}
			
			break;
		case "[object Boolean]":
			result_180794 = 1;
			break BeforeRet;
			break;
		case "[object Null]":
			result_180794 = 0;
			break BeforeRet;
			break;
		case "[object String]":
			result_180794 = 4;
			break BeforeRet;
			break;
		default: 
			break;
		}
	} while (false);

	return result_180794;

}

function is_fat_pointer_17201(ti_17203) {
	var result_17204 = false;

	BeforeRet: do {
		result_17204 = !((ConstSet1[ti_17203.base.kind] != undefined));
		break BeforeRet;
	} while (false);

	return result_17204;

}

function nimCopyAux(dest_17235, src_17236, n_17238) {
		switch (n_17238.kind) {
		case 0:
			break;
		case 1:
			      dest_17235[n_17238.offset] = nimCopy(dest_17235[n_17238.offset], src_17236[n_17238.offset], n_17238.typ);
    
			break;
		case 2:
			L1: do {
				var i_17628 = 0;
				var colontmp__17630 = 0;
				colontmp__17630 = (n_17238.len - 1);
				var res_17633 = 0;
				L2: do {
						L3: while (true) {
						if (!(res_17633 <= colontmp__17630)) break L3;
							i_17628 = res_17633;
							nimCopyAux(dest_17235, src_17236, n_17238.sons[i_17628]);
							res_17633 += 1;
						}
				} while(false);
			} while(false);
			break;
		case 3:
			      dest_17235[n_17238.offset] = nimCopy(dest_17235[n_17238.offset], src_17236[n_17238.offset], n_17238.typ);
      for (var i = 0; i < n_17238.sons.length; ++i) {
        nimCopyAux(dest_17235, src_17236, n_17238.sons[i][1]);
      }
    
			break;
		}

	
}

function new_jarray_160639() {
	var result_160641 = null;

		result_160641 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};
		result_160641.kind = 6;
		result_160641.elems = nimCopy(null, [], NTI160665);

	return result_160641;

}

function len_181015(x_181017) {
	var result_181018 = 0;

		      result_181018 = x_181017.length;
    

	return result_181018;

}

function add_161006(father_161008, child_161009) {
		if (father_161008.elems != null) { father_161008.elems.push(child_161009); } else { father_161008.elems = [child_161009]; };

	
}

function HEX5BHEX5D_181414(x_181416, y_181417) {
	var result_181418 = {};

		      result_181418 = x_181416[y_181417];
    

	return result_181418;

}

function init_ordered_table_160438(initial_size_160443) {
	var result_160445 = {data: null, counter: 0, first: 0, last: 0};

		result_160445.counter = 0;
		result_160445.first = -1;
		result_160445.last = -1;
		result_160445.data = new Array(initial_size_160443); for (var i=0;i<initial_size_160443;++i) {result_160445.data[i]={Field0: 0, Field1: 0, Field2: null, Field3: null};}
	return result_160445;

}

function new_jobject_160423() {
	var result_160425 = null;

		result_160425 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};
		result_160425.kind = 5;
		nimCopy(result_160425.fields, init_ordered_table_160438(4), NTI160228);

	return result_160425;

}

function HEX21HEX26_134016(h_134018, val_134019) {
	var result_134020 = 0;

		result_134020 = ((h_134018 + val_134019) >>> 0);
		result_134020 = ((result_134020 + (result_134020 << 10)) >>> 0);
		result_134020 = (result_134020 ^ ((result_134020 >>> 0) >>> 6));

	return result_134020;

}

function HEX21HEX24_134070(h_134072) {
	var result_134073 = 0;

		result_134073 = ((h_134072 + (h_134072 << 3)) >>> 0);
		result_134073 = (result_134073 ^ ((result_134073 >>> 0) >>> 11));
		result_134073 = ((result_134073 + (result_134073 << 15)) >>> 0);

	return result_134073;

}

function hash_134900(x_134902) {
	var result_134903 = 0;

		var h_134904 = 0;
		L1: do {
			var i_134916 = 0;
			var colontmp__134924 = 0;
			colontmp__134924 = ((x_134902 != null ? x_134902.length : 0) - 1);
			var res_134927 = 0;
			L2: do {
					L3: while (true) {
					if (!(res_134927 <= colontmp__134924)) break L3;
						i_134916 = res_134927;
						h_134904 = HEX21HEX26_134016(h_134904, x_134902[i_134916]);
						res_134927 += 1;
					}
			} while(false);
		} while(false);
		result_134903 = HEX21HEX24_134070(h_134904);

	return result_134903;

}

function is_filled_137491(hcode_137493) {
	var result_137494 = false;

		result_137494 = !((hcode_137493 == 0));

	return result_137494;

}

function next_try_137614(h_137616, max_hash_137617) {
	var result_137618 = 0;

		result_137618 = ((h_137616 + 1) & max_hash_137617);

	return result_137618;

}

function raw_get_161589(t_161595, key_161597, hc_161599, hc_161599_Idx) {
						var Tmp3;

	var result_161600 = 0;

	BeforeRet: do {
		hc_161599[hc_161599_Idx] = hash_134900(key_161597);
		if ((hc_161599[hc_161599_Idx] == 0)) {
		hc_161599[hc_161599_Idx] = 314159265;
		}
		
		var h_161612 = (hc_161599[hc_161599_Idx] & (t_161595.data != null ? (t_161595.data.length-1) : -1));
		L1: do {
				L2: while (true) {
				if (!is_filled_137491(t_161595.data[h_161612].Field0)) break L2;
						if (!(t_161595.data[h_161612].Field0 == hc_161599[hc_161599_Idx])) Tmp3 = false; else {							Tmp3 = eqStrings(t_161595.data[h_161612].Field2, key_161597);						}					if (Tmp3) {
					result_161600 = h_161612;
					break BeforeRet;
					}
					
					h_161612 = next_try_137614(h_161612, (t_161595.data != null ? (t_161595.data.length-1) : -1));
				}
		} while(false);
		result_161600 = (-1 - h_161612);
	} while (false);

	return result_161600;

}

function must_rehash_137509(length_137511, counter_137512) {
	var result_137513 = false;

		result_137513 = (((length_137511 * 2) < (counter_137512 * 3)) || ((length_137511 - counter_137512) < 4));

	return result_137513;

}

function raw_insert_164308(t_164315, data_164319, data_164319_Idx, key_164321, val_164323, hc_164325, h_164327) {
		data_164319[data_164319_Idx][h_164327].Field2 = nimCopy(null, key_164321, NTI138);
		data_164319[data_164319_Idx][h_164327].Field3 = val_164323;
		data_164319[data_164319_Idx][h_164327].Field0 = hc_164325;
		data_164319[data_164319_Idx][h_164327].Field1 = -1;
		if ((t_164315.first < 0)) {
		t_164315.first = h_164327;
		}
		
		if ((0 <= t_164315.last)) {
		data_164319[data_164319_Idx][t_164315.last].Field1 = h_164327;
		}
		
		t_164315.last = h_164327;

	
}

function enlarge_162731(t_162738) {
		var n_162746 = null;
		n_162746 = new Array(((t_162738.data != null ? t_162738.data.length : 0) * 2)); for (var i=0;i<((t_162738.data != null ? t_162738.data.length : 0) * 2);++i) {n_162746[i]={Field0: 0, Field1: 0, Field2: null, Field3: null};}		var h_162930 = t_162738.first;
		t_162738.first = -1;
		t_162738.last = -1;
		var Tmp1 = t_162738.data; t_162738.data = n_162746; n_162746 = Tmp1;		L2: do {
				L3: while (true) {
				if (!(0 <= h_162930)) break L3;
					var nxt_163161 = n_162746[h_162930].Field1;
					var eh_163379 = n_162746[h_162930].Field0;
					if (is_filled_137491(eh_163379)) {
					var j_163388 = (eh_163379 & (t_162738.data != null ? (t_162738.data.length-1) : -1));
					L4: do {
							L5: while (true) {
							if (!is_filled_137491(t_162738.data[j_163388].Field0)) break L5;
								j_163388 = next_try_137614(j_163388, (t_162738.data != null ? (t_162738.data.length-1) : -1));
							}
					} while(false);
					raw_insert_164308(t_162738, t_162738, "data", n_162746[h_162930].Field2, n_162746[h_162930].Field3, n_162746[h_162930].Field0, j_163388);
					}
					
					h_162930 = nxt_163161;
				}
		} while(false);

	
}

function raw_get_known_hc_165472(t_165478, key_165480, hc_165482) {
	var result_165483 = 0;

	BeforeRet: do {
		var h_165492 = (hc_165482 & (t_165478.data != null ? (t_165478.data.length-1) : -1));
		L1: do {
				L2: while (true) {
				if (!is_filled_137491(t_165478.data[h_165492].Field0)) break L2;
					if (((t_165478.data[h_165492].Field0 == hc_165482) && eqStrings(t_165478.data[h_165492].Field2, key_165480))) {
					result_165483 = h_165492;
					break BeforeRet;
					}
					
					h_165492 = next_try_137614(h_165492, (t_165478.data != null ? (t_165478.data.length-1) : -1));
				}
		} while(false);
		result_165483 = (-1 - h_165492);
	} while (false);

	return result_165483;

}

function HEX5BHEX5DHEX3D_161548(t_161555, key_161557, val_161559) {
		var hc_161560 = [0];
		var index_162290 = raw_get_161589(t_161555, key_161557, hc_161560, 0);
		if ((0 <= index_162290)) {
		t_161555.data[index_162290].Field3 = val_161559;
		}
		else {
			if (must_rehash_137509((t_161555.data != null ? t_161555.data.length : 0), t_161555.counter)) {
			enlarge_162731(t_161555);
			index_162290 = raw_get_known_hc_165472(t_161555, key_161557, hc_161560[0]);
			}
			
			index_162290 = (-1 - index_162290);
			raw_insert_164308(t_161555, t_161555, "data", key_161557, val_161559, hc_161560[0], index_162290);
			t_161555.counter += 1;
		}
		

	
}

function HEX5BHEX5DHEX3D_173278(obj_173280, key_173281, val_173282) {
		HEX5BHEX5DHEX3D_161548(obj_173280.fields, key_173281, val_173282);

	
}

function new_jint_160321(n_160323) {
	var result_160324 = null;

		result_160324 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};
		result_160324.kind = 2;
		result_160324.num = n_160323;

	return result_160324;

}

function new_jfloat_160347(n_160349) {
	var result_160350 = null;

		result_160350 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};
		result_160350.kind = 3;
		result_160350.fnum = n_160349;

	return result_160350;

}

function new_jstring_160269(s_160271) {
	var result_160272 = null;

		result_160272 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};
		result_160272.kind = 4;
		result_160272.str = nimCopy(null, s_160271, NTI138);

	return result_160272;

}

function new_jbool_160373(b_160375) {
	var result_160376 = null;

		result_160376 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};
		result_160376.kind = 1;
		result_160376.bval = b_160375;

	return result_160376;

}

function new_jnull_160399() {
	var result_160401 = null;

		result_160401 = {kind: 0, str: null, num: 0, fnum: 0.0, bval: false, fields: {data: null, counter: 0, first: 0, last: 0}, elems: null};

	return result_160401;

}

function convert_object_181614(x_181616) {
	var result_181617 = null;

		switch (get_var_type_180791(x_181616)) {
		case 6:
			result_181617 = new_jarray_160639();
			L1: do {
				var i_181628 = 0;
				var colontmp__181633 = 0;
				colontmp__181633 = len_181015(x_181616);
				var i_181636 = 0;
				L2: do {
						L3: while (true) {
						if (!(i_181636 < colontmp__181633)) break L3;
							i_181628 = i_181636;
							add_161006(result_181617, convert_object_181614(HEX5BHEX5D_181414(x_181616, i_181628)));
							i_181636 += 1;
						}
				} while(false);
			} while(false);
			break;
		case 5:
			result_181617 = new_jobject_160423();
			for (var property in x_181616) {
        if (x_181616.hasOwnProperty(property)) {
      
			var nim_property_181630 = null;
			var nim_value_181631 = {};
			nim_property_181630 = property; nim_value_181631 = x_181616[property];
			HEX5BHEX5DHEX3D_173278(result_181617, cstrToNimstr(nim_property_181630), convert_object_181614(nim_value_181631));
			}}
			break;
		case 2:
			result_181617 = new_jint_160321(x_181616);
			break;
		case 3:
			result_181617 = new_jfloat_160347(x_181616);
			break;
		case 4:
			result_181617 = new_jstring_160269(cstrToNimstr(x_181616));
			break;
		case 1:
			result_181617 = new_jbool_160373(x_181616);
			break;
		case 0:
			result_181617 = new_jnull_160399();
			break;
		}

	return result_181617;

}

function parse_json_181655(buffer_181657) {
	var result_181658 = null;

	BeforeRet: do {
		result_181658 = convert_object_181614(JSON.parse(toJSStr(buffer_181657)));
		break BeforeRet;
	} while (false);

	return result_181658;

}

function get_elems_160954(n_160956, default_160973) {
			var Tmp1;

	var result_160975 = null;

	BeforeRet: do {
			if ((n_160956 === null)) Tmp1 = true; else {				Tmp1 = !((n_160956.kind == 6));			}		if (Tmp1) {
		result_160975 = nimCopy(null, default_160973, NTI160957);
		break BeforeRet;
		}
		else {
			result_160975 = nimCopy(null, n_160956.elems, NTI160253);
			break BeforeRet;
		}
		
	} while (false);

	return result_160975;

}

function new_seq_198623(len_198627) {
	var result_198629 = null;

		result_198629 = new Array(len_198627); for (var i=0;i<len_198627;++i) {result_198629[i]=0.0;}
	return result_198629;

}

function get_float_160802(n_160804, default_160805) {
	var result_160806 = 0.0;

	BeforeRet: do {
		if ((n_160804 === null)) {
		result_160806 = default_160805;
		break BeforeRet;
		}
		
		switch (n_160804.kind) {
		case 3:
			result_160806 = n_160804.fnum;
			break BeforeRet;
			break;
		case 2:
			result_160806 = n_160804.num;
			break BeforeRet;
			break;
		default: 
			result_160806 = default_160805;
			break BeforeRet;
			break;
		}
	} while (false);

	return result_160806;

}

function json_to_points_198225(json_198229) {
	var result_198244 = null;

		L1: do {
			var p_198254 = null;
			var colontmp__198712 = null;
			colontmp__198712 = get_elems_160954(json_198229, []);
			var i_198715 = 0;
			var l_198717 = (colontmp__198712 != null ? colontmp__198712.length : 0);
			L2: do {
					L3: while (true) {
					if (!(i_198715 < l_198717)) break L3;
						p_198254 = colontmp__198712[i_198715];
						L4: do {
							var HEX3Atmp_198609 = get_elems_160954(p_198254, []);
							var i_198613 = 0;
							var result_198654 = new_seq_198623((HEX3Atmp_198609 != null ? HEX3Atmp_198609.length : 0));
							L5: do {
								var it_198663 = null;
								var i_198709 = 0;
								var l_198711 = (HEX3Atmp_198609 != null ? HEX3Atmp_198609.length : 0);
								L6: do {
										L7: while (true) {
										if (!(i_198709 < l_198711)) break L7;
											it_198663 = HEX3Atmp_198609[i_198709];
											result_198654[i_198613] = get_float_160802(it_198663, 0.0);
											i_198613 += 1;
											i_198709 += 1;
										}
								} while(false);
							} while(false);
						} while(false);
						var d_198676 = nimCopy(null, result_198654, NTI198628);
						if (result_198244 != null) { result_198244.push({Field0: d_198676[0], Field1: d_198676[1], Field2: d_198676[2], Field3: d_198676[3]}); } else { result_198244 = [{Field0: d_198676[0], Field1: d_198676[1], Field2: d_198676[2], Field3: d_198676[3]}]; };
						i_198715 += 1;
					}
			} while(false);
		} while(false);

	return result_198244;

}

function get_context2d_196728(c_196730) {
	var result_196731 = null;

		result_196731=c_196730.getContext('2d');

	return result_196731;

}

function high_198794() {
	var result_198799 = 0.0;

		result_198799 = Infinity;

	return result_198799;

}

function low_198822() {
	var result_198827 = 0.0;

		result_198827 = -Infinity;

	return result_198827;

}

function bounds_198774(points_198779) {
	var result_198791 = {Field0: 0.0, Field1: 0.0, Field2: 0.0, Field3: 0.0};

		result_198791.Field0 = high_198794();
		result_198791.Field1 = high_198794();
		result_198791.Field2 = low_198822();
		result_198791.Field3 = low_198822();
		L1: do {
			var i_198894 = 0;
			var point_198895 = {Field0: 0.0, Field1: 0.0, Field2: 0.0, Field3: 0.0};
			var i_198919 = 0;
			L2: do {
					L3: while (true) {
					if (!(i_198919 < (points_198779 != null ? points_198779.length : 0))) break L3;
						i_198894 = i_198919;
						nimCopy(point_198895, points_198779[i_198919], NTI198235);
						result_198791.Field0 = nimMin(result_198791.Field0, points_198779[i_198894].Field0);
						result_198791.Field1 = nimMin(result_198791.Field1, points_198779[i_198894].Field1);
						result_198791.Field2 = nimMax(result_198791.Field2, points_198779[i_198894].Field0);
						result_198791.Field3 = nimMax(result_198791.Field3, points_198779[i_198894].Field1);
						i_198919 += 1;
					}
			} while(false);
		} while(false);

	return result_198791;

}

function calc_fps_198948(bounds_198953) {
	var result_198954 = 0.0;

		var height_198955 = (bounds_198953.Field3 - bounds_198953.Field1);
		result_198954 = (height_198955 / 1.0000000000000000e+01);

	return result_198954;

}

function fill_styleHEX3D_196128(ctx_196130, color_196131) {
		ctx_196130.fillStyle=color_196131;

	
}

function canvas_196745(ctx_196747) {
	var result_196748 = null;

		result_196748=ctx_196747.canvas;

	return result_196748;

}

function clear_198128(ctx_198130) {
		ctx_198130.save();
		fill_styleHEX3D_196128(ctx_198130, "#0f0f23");
		ctx_198130.fillRect(0.0, 0.0, canvas_196745(ctx_198130).width, canvas_196745(ctx_198130).height);
		ctx_198130.restore();

	
}

function stroke_styleHEX3D_196179(ctx_196181, color_196182) {
		ctx_196181.strokeStyle=color_196182;

	
}

function draw_scale_axis_198053(ctx_198055, length_198056, value_198057) {
		ctx_198055.save();
		fill_styleHEX3D_196128(ctx_198055, "white");
		stroke_styleHEX3D_196179(ctx_198055, "white");
		ctx_198055.textAlign = "center";
		ctx_198055.textBaseline = "middle";
		ctx_198055.beginPath();
		ctx_198055.moveTo(3.0000000000000000e+01, 1.5000000000000000e+01);
		ctx_198055.lineTo((length_198056 - 3.0000000000000000e+01), 1.5000000000000000e+01);
		ctx_198055.moveTo(4.0000000000000000e+01, 1.0000000000000000e+01);
		ctx_198055.lineTo(3.0000000000000000e+01, 1.5000000000000000e+01);
		ctx_198055.lineTo(4.0000000000000000e+01, 2.0000000000000000e+01);
		ctx_198055.moveTo(((length_198056 - 3.0000000000000000e+01) - 1.0000000000000000e+01), 1.0000000000000000e+01);
		ctx_198055.lineTo((length_198056 - 3.0000000000000000e+01), 1.5000000000000000e+01);
		ctx_198055.lineTo(((length_198056 - 3.0000000000000000e+01) - 1.0000000000000000e+01), 2.0000000000000000e+01);
		ctx_198055.stroke();
		var text_h_metrics_198058 = ctx_198055.measureText(toJSStr(value_198057));
		fill_styleHEX3D_196128(ctx_198055, "#0f0f23");
		ctx_198055.fillRect((((length_198056 / 2.0000000000000000e+00) - (text_h_metrics_198058.width / 2.0000000000000000e+00)) - 1.0000000000000000e+01), 0.0, (text_h_metrics_198058.width + 2.0000000000000000e+01), 2.9000000000000000e+01);
		fill_styleHEX3D_196128(ctx_198055, "white");
		ctx_198055.fillText(toJSStr(value_198057), (length_198056 / 2.0000000000000000e+00), 1.5000000000000000e+01);
		ctx_198055.restore();

	
}

function draw_199020(points_199025, bounds_199028, ctx_199030) {
		var canvas_width_199031 = canvas_196745(ctx_199030).width;
		var canvas_height_199032 = canvas_196745(ctx_199030).height;
		var width_199033 = (bounds_199028.Field2 - bounds_199028.Field0);
		var height_199034 = (bounds_199028.Field3 - bounds_199028.Field1);
		var scale_x_199035 = ((canvas_width_199031 - 6.0000000000000000e+01) / (width_199033 + 1.0000000000000000e+00));
		var scale_y_199036 = ((canvas_height_199032 - 6.0000000000000000e+01) / (height_199034 + 1.0000000000000000e+00));
		ctx_199030.save();
		fill_styleHEX3D_196128(ctx_199030, "white");
		draw_scale_axis_198053(ctx_199030, canvas_width_199031, cstrToNimstr((((width_199033)|0))+""));
		ctx_199030.translate(0.0, canvas_height_199032);
		ctx_199030.rotate(-1.5707963267948966e+00);
		draw_scale_axis_198053(ctx_199030, canvas_height_199032, cstrToNimstr((((height_199034)|0))+""));
		ctx_199030.setTransform(1.0000000000000000e+00, 0.0, 0.0, 1.0000000000000000e+00, 0.0, 0.0);
		ctx_199030.translate(3.0000000000000000e+01, 3.0000000000000000e+01);
		ctx_199030.scale(scale_x_199035, scale_y_199036);
		ctx_199030.translate(-(bounds_199028.Field0), -(bounds_199028.Field1));
		L1: do {
			var point_199215 = {Field0: 0.0, Field1: 0.0, Field2: 0.0, Field3: 0.0};
			var i_199229 = 0;
			var l_199231 = (points_199025 != null ? points_199025.length : 0);
			L2: do {
					L3: while (true) {
					if (!(i_199229 < l_199231)) break L3;
						nimCopy(point_199215, points_199025[i_199229], NTI198235);
						ctx_199030.fillRect(point_199215.Field0, point_199215.Field1, 1.0000000000000000e+00, 1.0000000000000000e+00);
						i_199229 += 1;
					}
			} while(false);
		} while(false);
		ctx_199030.restore();

	
}

function frame_198991(points_198996, bounds_198999, ctx_199001) {
		clear_198128(ctx_199001);
		draw_199020(points_198996, bounds_198999, ctx_199001);

	
}

function move_sky_199275(points_199281, points_199281_Idx, reverse_199283, ratio_199285) {
	var result_199287 = {Field0: 0.0, Field1: 0.0, Field2: 0.0, Field3: 0.0};

		result_199287.Field0 = high_198794();
		result_199287.Field1 = high_198794();
		result_199287.Field2 = low_198822();
		result_199287.Field3 = low_198822();
		L1: do {
			var i_199329 = 0;
			var point_199330 = {Field0: 0.0, Field1: 0.0, Field2: 0.0, Field3: 0.0};
			var colontmp__199372 = null;
			colontmp__199372 = points_199281[points_199281_Idx];
			var i_199375 = 0;
			L2: do {
					L3: while (true) {
					if (!(i_199375 < (colontmp__199372 != null ? colontmp__199372.length : 0))) break L3;
						i_199329 = i_199375;
						nimCopy(point_199330, colontmp__199372[i_199375], NTI198235);
						if (reverse_199283) {
						points_199281[points_199281_Idx][i_199329].Field0 = (point_199330.Field0 - (point_199330.Field2 * ratio_199285));
						points_199281[points_199281_Idx][i_199329].Field1 = (point_199330.Field1 - (point_199330.Field3 * ratio_199285));
						}
						else {
							points_199281[points_199281_Idx][i_199329].Field0 = (point_199330.Field0 + (point_199330.Field2 * ratio_199285));
							points_199281[points_199281_Idx][i_199329].Field1 = (point_199330.Field1 + (point_199330.Field3 * ratio_199285));
						}
						
						result_199287.Field0 = nimMin(result_199287.Field0, points_199281[points_199281_Idx][i_199329].Field0);
						result_199287.Field1 = nimMin(result_199287.Field1, points_199281[points_199281_Idx][i_199329].Field1);
						result_199287.Field2 = nimMax(result_199287.Field2, points_199281[points_199281_Idx][i_199329].Field0);
						result_199287.Field3 = nimMax(result_199287.Field3, points_199281[points_199281_Idx][i_199329].Field1);
						i_199375 += 1;
					}
			} while(false);
		} while(false);

	return result_199287;

}

function quit_199435(old_bounds_199440, new_bounds_199443) {
	var result_199444 = false;

	BeforeRet: do {
		var last_height_199445 = (old_bounds_199440.Field3 - old_bounds_199440.Field1);
		var height_199446 = (new_bounds_199443.Field3 - new_bounds_199443.Field1);
		var last_width_199447 = (old_bounds_199440.Field2 - old_bounds_199440.Field0);
		var width_199448 = (new_bounds_199443.Field2 - new_bounds_199443.Field0);
		result_199444 = ((last_width_199447 < width_199448) || (last_height_199445 < height_199446));
		break BeforeRet;
	} while (false);

	return result_199444;

}

function loop_198748(points_198754, points_198754_Idx, canvas_198756) {

		function run_198970(timestamp_198972) {
			BeforeRet: do {
				frame_198991(points_198754[points_198754_Idx], bounds_198933, ctx_198757);
				if ((6.0000000000000000e+01 <= fps_198969)) {
				nimCopy(bounds_198933, move_sky_199275(points_198754, points_198754_Idx, false, (fps_198969 / 6.0000000000000000e+01)), NTI198782);
				}
				else {
					var new_bounds_199418 = move_sky_199275(points_198754, points_198754_Idx, false, (1.0000000000000000e+00 / (6.0000000000000000e+01 - fps_198969)));
					if (quit_199435(bounds_198933, new_bounds_199418)) {
					canvas_198756.addEventListener("click", canvas_on_click_198187, false);
					break BeforeRet;
					}
					
					nimCopy(bounds_198933, new_bounds_199418, NTI198782);
				}
				
				fps_198969 = calc_fps_198948(bounds_198933);
				window.requestAnimationFrame(run_198970);
			} while (false);

			
		}

		var ctx_198757 = get_context2d_196728(canvas_198756);
		var bounds_198933 = bounds_198774(points_198754[points_198754_Idx]);
		var fps_198969 = calc_fps_198948(bounds_198933);
		ctx_198757.font = "14px Monospace";
		window.requestAnimationFrame(run_198970);

	
}

function canvas_on_click_198187(e_198189) {
		var element_198220 = e_198189.target;
		var data_id_198221 = element_198220.getAttribute("data-data-id");
		var data_198222 = parse_json_181655(cstrToNimstr(document.getElementById(data_id_198221).innerHTML));
		element_198220.removeEventListener("click", canvas_on_click_198187, false);
		var points_198731 = [json_to_points_198225(data_198222)];
		loop_198748(points_198731, 0, element_198220);

	
}

function HEX3Aanonymous_199522(e_199525) {
		var elements_199526 = document.getElementsByClassName("day10-canvas");
		L1: do {
			var i_199573 = 0;
			var __199574 = null;
			var i_199578 = 0;
			L2: do {
					L3: while (true) {
					if (!(i_199578 < (elements_199526 != null ? elements_199526.length : 0))) break L3;
						i_199573 = i_199578;
						__199574 = elements_199526[i_199578];
						elements_199526[i_199573].addEventListener("click", canvas_on_click_198187, false);
						i_199578 += 1;
					}
			} while(false);
		} while(false);

	
}
window.onload = HEX3Aanonymous_199522;
