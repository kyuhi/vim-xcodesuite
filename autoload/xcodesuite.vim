
let s:V = vital#of( 'xcodesuite' )
let s:Path = s:V.import( 'System.Filepath' )
let s:Message = s:V.import( 'Vim.Message' )
let s:Process = s:V.import( 'Process' )

func! xcodesuite#open()
    let projdir = s:get_projectdir_of_currentdir()
    if projdir == ''
        return
    endif
    silent exe '!open ' . projdir
endfunc


func! xcodesuite#build()
    " TODO: require options
    let projdir = s:get_projectdir_of_currentdir()
    if '' == projdir
        return
    endif
    let cwd = getcwd()
    let projroot = s:Path.dirname( projdir )
    call s:cwd( projroot )
    exec '!xcodebuild'
    call s:cwd( cwd )
endfunc


func! xcodesuite#sdk_path( sdk )
    return s:xcrun_show( '--show-sdk-path', a:sdk )
endfunc


func! xcodesuite#sdk_version( sdk )
    return s:xcrun_show( '--show-sdk-version', a:sdk )
endfunc


func! xcodesuite#sdk_platform_path( sdk )
    return s:xcrun_show( '--show-sdk-platform-path', a:sdk )
endfunc


func! xcodesuite#sdk_platform_version( sdk )
    return s:xcrun_show( '--show-sdk-platform-version', a:sdk )
endfunc


func! xcodesuite#tool_path( toolname, sdk )
    if s:validate_sdk( a:sdk )
        let cmd = 'xcrun -f --sdk ' . a:sdk . ' ' . a:toolname . ' 2>/dev/null'
        return s:Process.system( cmd )
    endif
endfunc


func! s:get_projectdir_of_currentdir()
    for dirname in s:upwrads_directories( expand( '%:p' ) )
        if -1 != match( dirname, '.xcodeproj' )
            return dirname
        endif
    endfor
    return ''
endfunc


func! s:upwrads_directories( filepath )
    let work = s:Path.dirname( a:filepath )
    let result = [ work ]
    while work != s:Path.separator()
        let work = s:Path.dirname( work )
        call add( result, work )
    endwhile
    return result
endfunc


func! s:cwd( directory )
    exec 'lcd' . a:directory
endfunc


func! s:validate_sdk( sdk )
    if 'iphoneos' == a:sdk || a:sdk == 'macos' || a:sdk == 'iphonesimulator'
        return 1
    endif
    call Message.echomsg( ErrorMsg,
                \ "expected iphoneos or macos or iphonesimulator" )
    return 0
endfunc


func! s:xcrun_show( option, sdk )
    if s:validate_sdk( a:sdk )
        let cmd = 'xcrun ' . a:option . ' --sdk ' . a:sdk . ' 2>/dev/null'
        return s:Process.system( cmd )
    endif
endfunc
