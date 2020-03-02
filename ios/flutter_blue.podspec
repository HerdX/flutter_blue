#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'flutter_blue'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'McuManager', '~> 0.8.0'
  s.dependency '!ProtoCompiler'
  s.framework = 'CoreBluetooth'

  # try with 'ios'
  if File.exist?(ENV['PWD'] + '/ios/Pods/!ProtoCompiler/protoc')
    protoc =  ENV['PWD'] + '/ios/Pods/!ProtoCompiler/protoc'
  end
  # try without 'ios'
  if File.exist?(ENV['PWD'] + '/Pods/!ProtoCompiler/protoc')
    protoc =  ENV['PWD'] + '/Pods/!ProtoCompiler/protoc'
  end

  objc_out = 'gen'
  proto_in = '../protos'
  s.prepare_command = <<-CMD
    mkdir -p #{objc_out}
    #{protoc} \
        --objc_out=#{objc_out} \
        --proto_path=#{proto_in} \
        #{proto_in}/*.proto
  CMD

  s.subspec 'Protos' do |ss|
    ss.source_files = 'gen/**/*.pbobjc.{h,m}'
    # ss.header_mappings_dir = 'gen'
    ss.requires_arc = false
    ss.dependency 'Protobuf'
  end

     # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
     s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1', }
     s.ios.deployment_target = '9.0'
end

