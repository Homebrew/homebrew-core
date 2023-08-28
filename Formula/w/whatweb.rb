class Whatweb < Formula
  desc "Web scanner. Identify the technology stack that powers a website"
  homepage "https://morningstarsecurity.com/research/whatweb"
  url "https://github.com/urbanadventurer/WhatWeb/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "96dedb6a377184fb8f5fd3f2a81c26ff8c92c4dc1503ce409793a1e7ab23695d"
  license "GPL-2.0-only"
  head "https://github.com/urbanadventurer/WhatWeb.git", branch: "master"

  uses_from_macos "ruby" => :build, since: :ventura

  def install
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "config", "--local", "#{libexec}/whatweb"
    system "bundle", "install"
    system "make", "install",
      "prefix=#{prefix}",
      "-e", "BINPATH=#{bin}",
      "-e", "DOCPATH=#{doc}",
      "-e", "LIBPATH=#{lib}",
      "-e", "MANPATH=#{man}"
  end

  test do
    target_test = shell_output("#{bin}/whatweb --log-json=test.json --verbose --color=never google.com").strip
    log_test = File.exist?("test.json")
    assert_equal true, log_test
    assert_match(/Status\s\s\s\s:\s[0-9]+/, target_test)
    assert_match(/Title\s\s\s\s\s:\sGoogle/, target_test)
    assert_match(/Country\s\s\s:\sUNITED\sSTATES(,)\sUS/, target_test)
    version_test = shell_output("#{bin}/whatweb --version").strip
    assert_equal "WhatWeb version #{version} ( https://www.morningstarsecurity.com/research/whatweb/ )", version_test
  end
end
