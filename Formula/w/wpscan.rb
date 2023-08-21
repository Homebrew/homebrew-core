class Wpscan < Formula
  desc "WordPress security scanner"
  homepage "https://wpscan.com"
  url "https://github.com/wpscanteam/wpscan/archive/refs/tags/v3.8.24.tar.gz"
  sha256 "03d1852e9cb7e50c175f5699cd4055494ce379d6b2a931cdb8ca6000c932f767"
  license :cannot_represent # Source is public, commercial use requires a paid license
  head "https://github.com/wpscanteam/wpscan.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "061486585f55e99314f0c9c780c292068dcaec8e8a57a709219622a41df26597"
    sha256                               arm64_monterey: "d7af224790e97fbe5501ca63348316b419dc5ab477e17a3417f64ad428fc54d5"
    sha256                               arm64_big_sur:  "f9a53bdbe66814ba0fd7bd0f03c824fc32f7a55b0f6d7f51d425025d1a47029c"
    sha256                               ventura:        "f5580ce4710e99c3a10417bffe467df192378957c614f23910c17e8c266accc6"
    sha256                               monterey:       "05bcd7784f5edfa8c2e4f73f70cb27d05eda9e2977efe496a75553e2f8323382"
    sha256                               big_sur:        "f137dee75e90db661cf3ba9ad4c6e510484723c0a1dad17369c45c356895ccc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee7317717fc3e11acab6c721aca52977b06f991f11e52ee2a5746f52f500a70"
  end

  depends_on "xz" # for liblzma

  uses_from_macos "ruby"

  # cms_scanner 0.13.8 -> ethon 0.15.0 -> ffi 1.15.5
  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  # cms_scanner 0.13.8 -> ethon 0.15.0
  resource "ethon-0.15.0" do
    url "https://rubygems.org/downloads/ethon-0.15.0.gem"
    sha256 "0809805a035bc10f54162ca99f15ded49e428e0488bcfe1c08c821e18261a74d"
  end

  # cms_scanner 0.13.8 -> get_process_mem 0.2.7 -> ffi 1.15.5
  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  # cms_scanner 0.13.8 -> get_process_mem 0.2.7
  resource "get_process_mem" do
    url "https://rubygems.org/downloads/get_process_mem-0.2.7.gem"
    sha256 "4afd3c3641dd6a817c09806c7d6d509d8a9984512ac38dea8b917426bbf77eba"
  end

  # cms_scanner 0.13.8 -> nokogiri 1.13.10 -> mini_portile2 2.82
  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.8.2.gem"
    sha256 "46b2d244cc6ff01a89bf61274690c09fdbdca47a84ae9eac39039e81231aee7c"
  end

  # cms_scanner 0.13.8 -> nokogiri 1.13.10 -> racc 1.7.1
  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.7.1.gem"
    sha256 "af64124836fdd3c00e830703d7f873ea5deabde923f37006a39f5a5e0da16387"
  end

  # cms_scanner 0.13.8 -> nokogiri 1.13.10
  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.13.10.gem"
    sha256 "d3ee00f26c151763da1691c7fc6871ddd03e532f74f85101f5acedc2d099e958"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> concurrent-ruby 1.2.2
  resource "concurrent-ruby" do
    url "https://rubygems.org/downloads/concurrent-ruby-1.2.2.gem"
    sha256 "3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> i18n 1.14.1 -> concurrent-ruby 1.2.2
  resource "concurrent-ruby" do
    url "https://rubygems.org/downloads/concurrent-ruby-1.2.2.gem"
    sha256 "3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> i18n 1.14.1
  resource "i18n" do
    url "https://rubygems.org/downloads/i18n-1.14.1.gem"
    sha256 "9d03698903547c060928e70a9bc8b6b87fda674453cda918fc7ab80235ae4a61"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> minitest 5.18.1
  resource "minitest" do
    url "https://rubygems.org/downloads/minitest-5.18.1.gem"
    sha256 "ab5ee381871aaddc3a6aa2a6abcab5c4590fec9affc20947d63f312a0fe4e9cd"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> tzinfo 2.0.6 -> concurrent-ruby 1.2.2
  resource "concurrent-ruby" do
    url "https://rubygems.org/downloads/concurrent-ruby-1.2.2.gem"
    sha256 "3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> tzinfo 2.0.6
  resource "tzinfo" do
    url "https://rubygems.org/downloads/tzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4 -> zeitwerk 2.6.8
  resource "zeitwerk" do
    url "https://rubygems.org/downloads/zeitwerk-2.6.8.gem"
    sha256 "7361fc7da53b2a81b49ab2d38792b78e99690095659c11609b6d1cc58f5c6632"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> activesupport 6.1.7.4
  resource "activesupport" do
    url "https://rubygems.org/downloads/activesupport-6.1.7.4.gem"
    sha256 "3599df3432172cbd204844cf6f7743a954e115441cd988357bcc999b422a8668"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> addressable 2.8.4 -> public_suffix 5.0.3
  resource "public_suffix-5.0.3" do
    url "https://rubygems.org/downloads/public_suffix-5.0.3.gem"
    sha256 "337d475da2bd2ea1de0446751cb972ad43243b4b00aa8cf91cb904fa593d3259"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5 -> addressable 2.8.4
  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.8.4.gem"
    sha256 "40a88af5285625b7fb14070e550e667d5b0cc91f748068701b4d897cacda4897"
  end

  # cms_scanner 0.13.8 -> opt_parse_validator 1.9.5
  resource "opt_parse_validator" do
    url "https://rubygems.org/downloads/opt_parse_validator-1.9.5.gem"
    sha256 "2c69ece2110436148ecb78f1a5f768a7e3fd3d81db3517a484eb649de0b0f5cb"
  end

  # cms_scanner 0.13.8 -> public_suffix 4.0.7
  resource "public_suffix-4.0.7" do
    url "https://rubygems.org/downloads/public_suffix-4.0.7.gem"
    sha256 "8be161e2421f8d45b0098c042c06486789731ea93dc3a896d30554ee38b573b8"
  end

  # cms_scanner 0.13.8 -> ruby-progressbar 1.11.0
  resource "ruby-progressbar" do
    url "https://rubygems.org/downloads/ruby-progressbar-1.11.0.gem"
    sha256 "cc127db3866dc414ffccbf92928a241e585b3aa2b758a5563e74a6ee0f57d50a"
  end

  # cms_scanner 0.13.8 -> sys-proctable 1.2.7 -> ffi 1.15.5
  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  # cms_scanner 0.13.8 -> sys-proctable 1.2.7
  resource "sys-proctable" do
    url "https://rubygems.org/downloads/sys-proctable-1.2.7.gem"
    sha256 "50252ca7ae3792c0fb4c5f4306697f10b4d9da73fa042d29e4eaa64017e83188"
  end

  # cms_scanner 0.13.8 -> typhoeus 1.4.0 -> ethon 0.16.0 -> ffi 1.15.5
  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  # cms_scanner 0.13.8 -> typhoeus 1.4.0 -> ethon 0.16.0
  resource "ethon-0.16.0" do
    url "https://rubygems.org/downloads/ethon-0.16.0.gem"
    sha256 "bba0da1cea8ac3e1f5cdd7cb1cb5fc78d7ac562c33736f18f0c3eb2b63053d9e"
  end

  # cms_scanner 0.13.8 -> typhoeus 1.4.0
  resource "typhoeus" do
    url "https://rubygems.org/downloads/typhoeus-1.4.0.gem"
    sha256 "fff9880d5dc35950e7706cf132fd297f377c049101794be1cf01c95567f642d4"
  end

  # cms_scanner 0.13.8 -> xmlrpc 0.3.2 -> webrick 1.8.1
  resource "webrick" do
    url "https://rubygems.org/downloads/webrick-1.8.1.gem"
    sha256 "19411ec6912911fd3df13559110127ea2badd0c035f7762873f58afc803e158f"
  end

  # cms_scanner 0.13.8 -> xmlrpc 0.3.2
  resource "xmlrpc" do
    url "https://rubygems.org/downloads/xmlrpc-0.3.2.gem"
    sha256 "579ac5fc5cafdac7db6898ba104ca537a03ab079253334aea2de9c347c4e47f5"
  end

  # cms_scanner 0.13.8 -> yajl-ruby 1.4.3
  resource "yajl-ruby" do
    url "https://rubygems.org/downloads/yajl-ruby-1.4.3.gem"
    sha256 "8c974d9c11ae07b0a3b6d26efea8407269b02e4138118fbe3ef0d2ec9724d1d2"
  end

  # cms_scanner 0.13.8
  resource "cms_scanner" do
    url "https://rubygems.org/downloads/cms_scanner-0.13.8.gem"
    sha256 "d271feb53d96b01089b512e27080537de92501f224cf479ffd9ce599b36ca795"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      # Fix segmentation fault on Apple Silicon
      # Ref: https://github.com/ffi/ffi/issues/864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if r.name == "ffi" && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", r.cached_download, *args
    end

    system "gem", "build", "wpscan.gemspec"
    system "gem", "install", "wpscan-#{version}.gem"
    bin.install libexec/"bin/wpscan"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    if OS.mac?
      shims_references = Dir[libexec/"extensions/**/ffi-*/mkmf.log"].select { |f| File.file? f }
      inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>", false
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wpscan --version")

    assert_match "Update completed", shell_output("#{bin}/wpscan --update")
  end
end
