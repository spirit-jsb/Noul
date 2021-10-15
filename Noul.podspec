Pod::Spec.new do |s|

    s.name = 'Noul'
    s.version = '1.0.0'
    
    s.summary = 'Noul 是一个用于获取 OGP (Open Graph protocol) 信息的 Swift 实现'
    s.description = <<-DESC 
                    Noul 是一个用于获取 OGP (Open Graph protocol) 信息的 Swift 实现，你可以通过下标的形式获取具体的数据
                    DESC

    s.homepage = 'https://github.com/spirit-jsb/Noul.git'

    s.authors = {'spirit-jsb' => 'sibo_jian_29903549@163.com'}
    
    s.license = 'MIT'
    
    s.swift_version = '5.0'

    s.ios.deployment_target = '13.0'
    
    s.source = { :git => 'https://github.com/spirit-jsb/Noul.git', :tag => s.version}
    s.source_files = ["Sources/**/*.swift"]
    
    s.requires_arc = true
    s.frameworks = 'Foundation', 'Combine'

end