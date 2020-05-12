class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/v1.9.0.tar.gz"
  sha256 "a9a37fb56657489e3650bb743f8a7eb400c75865cf86458b80440bd44afa7500"

  bottle do
    sha256 "d743573d4c3a39da87591b014fc06e0e3152ccef6f6966baa63148a9c46d79cb" => :catalina
    sha256 "8f5669835882ae56195eea82922f70ee76d92a9d7d9dbe639fbf62de69e1d248" => :mojave
    sha256 "10c1b805c55364cc4fe0ee99523a0c30484551490d708238100d027782aa89cb" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  if MacOS.version < :catalina
    depends_on "libffi"
  else
    uses_from_macos "libffi"
  end

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-5.2.4.2.gem"
    sha256 "8c3ae3df5b08b49b6b5d9c5028da1a1e582f1243b7362dbb9736f65ede492378"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.6.gem"
    sha256 "14da21d5cfe9ccb02e9359b01cb7291e0167ded0ec805d4f3a4b2b4ffa418324"
  end

  resource "i18n" do
    url "https://rubygems.org/gems/i18n-1.8.2.gem"
    sha256 "95cf147081cc6f1dbfb32a8f29a03afe8b0f4da6a300d37d34e0f74a6868994b"
  end

  resource "minitest" do
    url "https://rubygems.org/gems/minitest-5.14.0.gem"
    sha256 "dfe35170edd195c3f32b43c2326a776e687f9efb330f185e43f0ca0a8be9e33c"
  end

  resource "tzinfo" do
    url "https://rubygems.org/gems/tzinfo-1.2.7.gem"
    sha256 "3945d8a57c62a59e691d527ae4daaf562d6e07a3c0d032876c6b066e108072c4"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.4.gem"
    sha256 "3ff2a10253583b2780b6fb0ea643a2e877ae3bf719bd987fe5f16b550ec733d0"
  end

  resource "ethon" do
    url "https://rubygems.org/gems/ethon-0.12.0.gem"
    sha256 "e99d3095e89f82c5a7e63d9261ddf4a21f28ae5d12a9d3abaa6920cce6cbef3d"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-1.0.1.gem"
    sha256 "381aee04fcc9effbe5fa7cc703d8f5f20293722f987ded4f958f77514cd29373"
  end

  resource "faraday_middleware" do
    url "https://rubygems.org/gems/faraday_middleware-1.0.0.gem"
    sha256 "19e808539681bbf2e65df30dfbe27bb402bde916a1dceb4c7496dbe8de14334a"
  end

  # required by typhoeus
  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.12.2.gem"
    sha256 "048ad01d5369f67075f943c16f1058f10663af2a66eedb87d921316ba1828e82"
  end

  resource "gh" do
    url "https://rubygems.org/gems/gh-0.17.0.gem"
    sha256 "7219a131780f2f21b7495e60e94dd5170e5ab6dc9a219f4623ca4175456d42da"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.3.gem"
    sha256 "2ddd5c127d4692721486f91737307236fe005352d12a4202e26c48614f719479"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.3.0.gem"
    sha256 "b61691fd2087ac37141b75ff4287ce2c3f17251c713e97ef73b43b4bb2e0355b"
  end

  # launchy v2.5.0 requires ruby > 2.4.0
  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.4.3.gem"
    sha256 "42f52ce12c6fe079bac8a804c66522a0eefe176b845a62df829defe0e37214a4"
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.13.1.gem"
    sha256 "db8613c039b9501e6b2fb85efe4feabb02f55c3365bae52bba35381b89c780e6"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.1.1.gem"
    sha256 "d2dd7aa957650e0d99e0513cd388401b069f09528441b87d884609c8e94ffcfd"
  end

  resource "net-http-persistent" do
    url "https://rubygems.org/gems/net-http-persistent-2.9.4.gem"
    sha256 "24274d207ffe66222ef70c78a052c7ea6e66b4ff21e2e8a99e3335d095822ef9"
  end

  resource "net-http-pipeline" do
    url "https://rubygems.org/gems/net-http-pipeline-1.0.1.gem"
    sha256 "6923ce2f28bfde589a9f385e999395eead48ccfe4376d4a85d9a77e8c7f0b22f"
  end

  resource "pusher-client" do
    url "https://rubygems.org/gems/pusher-client-0.6.2.gem"
    sha256 "c405c931090e126c056d99f6b69a01b1bcb6cbfdde02389c93e7d547c6efd5a3"
  end

  resource "thread_safe" do
    url "https://rubygems.org/gems/thread_safe-0.3.6.gem"
    sha256 "9ed7072821b51c57e8d6b7011a8e282e25aeea3a4065eab326e43f66f063b05a"
  end

  resource "typhoeus" do
    url "https://rubygems.org/gems/typhoeus-0.8.0.gem"
    sha256 "28b7cf3c7d915a06d412bddab445df94ab725252009aa409f5ea41ab6577a30f"
  end

  resource "websocket" do
    url "https://rubygems.org/gems/websocket-1.2.8.gem"
    sha256 "1d8155c1cdaab8e8e72587a60e08423c9dd84ee44e4e827358ce3d4c2ccb2138"
  end

  def install
    ENV["GEM_HOME"] = libexec
    # gem issue on Mojave
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :mojave

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "travis.gemspec"
    system "gem", "install", "--ignore-dependencies", "travis-#{version}.gem"
    bin.install libexec/"bin/travis"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    (testpath/".travis.yml").write <<~EOS
      language: ruby

      matrix:
        include:
          - os: osx
            rvm: system
    EOS
    output = shell_output("#{bin}/travis lint #{testpath}/.travis.yml")
    assert_match "valid", output
    output = shell_output("#{bin}/travis init 2>&1", 1)
    assert_match "Can't figure out GitHub repo name", output
  end
end
