Pod::Spec.new do |s|

  s.name         = "PLVTimer"
  s.version      = "0.0.2"
  s.summary      = "高效易用安全 GCD 定时器"
  s.description  = <<-DESC
  PLVTimer
  高效易用安全 GCD 定时器
                   DESC
  s.homepage     = "https://github.com/polyv/PLVTimer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "bqlin" => "bqlins@163.com" }

  s.source       = { :git => "https://github.com/polyv/PLVTimer.git", :tag => "#{s.version}" }
  s.source_files  = "PLVTimer/*.{h,m}"
  s.requires_arc = true

end
