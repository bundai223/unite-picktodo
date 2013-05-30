" Unite Pick TODO ================================
let s:unite_source_picktodo = {
    \   'name' : 'picktodo',
    \   'hooks': {},
    \}

function! s:get_SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

let s:SID = s:get_SID()
delfunction s:get_SID

function! s:Todo_source_hooks_on_init(args, context)
    let a:context.source__picktodo_target_bufno = bufnr('%')
     let g:aaaaaaaaaaaaaaaaa = bufnr('#') . ' : ' . expand('#' . bufnr('#') . ':p')
endfunction

function! s:Todo_source_async_gather_candidate(args, context)

    " まず前回のキャッシュをクリア
    let a:context.source.unite__cached_candidates = []

    let bufNo = a:context.source__picktodo_target_bufno
    let lines  = getbufline(bufNo, 1, '$')
    let path   = expand('#' . bufNo . ':p')

    " TODOの行をリストアップ
    let candidate_list = []
    let line_index = 0
    for line in lines
        let index = match(line, 'TODO')
        if 0 <= index
            call add(candidate_list, [line_index, line[index : -1]])
        endif
        let line_index = line_index + 1
    endfor

    let format = '%' . strlen(line_index) . 'd: %s'
    let result = map(candidate_list, '{
                \   "word"          : printf(format, v:val[0], v:val[1]),
                \   "source"        : "picktodo",
                \   "kind"          : "jump_list",
                \   "action__path"  : path,
                \   "action__line"  : v:val[0] + 1,
                \}')
    return result
endfunction

let s:unite_source_picktodo.hooks.on_init           = function(s:SID . 'Todo_source_hooks_on_init')
let s:unite_source_picktodo.async_gather_candidates = function(s:SID . 'Todo_source_async_gather_candidate')

function! unite#sources#picktodo#define()
  return s:unite_source_picktodo
endfunction

"unlet s:unite_source_picktodo

