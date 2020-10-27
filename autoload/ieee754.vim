function! ieee754#nr2ieee(nr) abort "{{{
	let l:signal = a:nr < 0 ? 1 : 0
	let l:temp = float2nr(floor(log(abs(a:nr))/log(2)))
	let l:exponent = printf('%b', l:temp + 127)
	if len(l:exponent) > 8
		echohl WarningMsg
		echo 'Overflow!'
		echohl None
		return
	endif
	let l:float = printf('%b', float2nr((abs(a:nr)/pow(2, l:temp) - 1)*pow(2, 23)))
	return printf('%x', str2nr(l:signal .. l:exponent .. l:float, 2))
endfunction "}}}

function! ieee754#ieee2nr(ieee) abort "{{{
	let l:ieee = printf('%b', str2nr(a:ieee, 16))
	let l:rest = 32 - len(l:ieee)
	if l:rest >= 0
		let l:ieee = repeat('0', l:rest) .. l:ieee
	else
		echohl WarningMsg
		echo 'Overflow!'
		echohl None
		return
	endif
	let l:signal = l:ieee[0] ? -1 : 1 
	let l:temp = str2nr(l:ieee[1:8], 2)
	let l:exponent = l:temp - 127
	let l:float = str2nr('1' .. l:ieee[9:], 2)/pow(2, 23)
	return l:signal*l:float*pow(2, l:exponent)
endfunction "}}}
