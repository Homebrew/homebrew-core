class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/v1.11.1.tar.gz"
  sha256 "438b30362b54ed5c8668abf4212f239ac9081ab3aeb7cb9a24a9bf4b044495c3"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b8b0df541c9731bb23101d0ce5848edde1ef3de1c57672a6364de0d59029996"
    sha256 cellar: :any,                 arm64_monterey: "9f970f517ee07fd631f8413dc5258a2673004774adc123afb25ca1898083fdd3"
    sha256 cellar: :any,                 arm64_big_sur:  "cc488bfe2d8e576d6ae11665e3140019f25e8fe1239c65f3122b311217ea2c75"
    sha256 cellar: :any,                 ventura:        "55851004f709e1ce460af6958f99d43f47c0ada9a32b52cbe77df6d3f9ce5c01"
    sha256 cellar: :any,                 monterey:       "6de804e665cc162474f236240206a8440d732cabf28eeab31a11b10ce8fcedf2"
    sha256 cellar: :any,                 big_sur:        "c6738baf45ae5a6853dfa23893c0291a085ae0047166c0af188e654e7f1d149d"
    sha256 cellar: :any,                 catalina:       "a5d9904fb3347ee3960ecccd760d324a47cb010f869cf93e286574635b588b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "106dded68216c4cc89fb36f1398caef520ccd8c2b47666e5fc5ff10b9f125b51"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-5.2.8.1.gem"
    sha256 "f0498c616e1b243c7b56d67920c389f959c186ad7031569e80335b42e1d22564"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.0.gem"
    sha256 "f76d29d2d1f54b6c6a49aec58f9583b08d97e088c227a3fcba92f6c6531d5908"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.10.gem"
    sha256 "244cb1ca0d91ec2c15ca2209507c39fb163336994428e16fbd3f465c87bd8e68"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-1.10.1.gem"
    sha256 "38e5d43359ad0e8579af549fcc6083c03ffbeb0dd6fd78dee359263fde2cfc0c"
  end

  resource "faraday-em_http" do
    url "https://rubygems.org/gems/faraday-em_http-1.0.0.gem"
    sha256 "7a3d4c7079789121054f57e08cd4ef7e40ad1549b63101f38c7093a9d6c59689"
  end

  resource "faraday-em_synchrony" do
    url "https://rubygems.org/gems/faraday-em_synchrony-1.0.0.gem"
    sha256 "460dad1c30cc692d6e77d4c391ccadb4eca4854b315632cd7e560f74275cf9ed"
  end

  resource "faraday-excon" do
    url "https://rubygems.org/gems/faraday-excon-1.1.0.gem"
    sha256 "b055c842376734d7f74350fe8611542ae2000c5387348d9ba9708109d6e40940"
  end

  resource "faraday-httpclient" do
    url "https://rubygems.org/gems/faraday-httpclient-1.0.1.gem"
    sha256 "4c8ff1f0973ff835be8d043ef16aaf54f47f25b7578f6d916deee8399a04d33b"
  end

  resource "faraday-multipart" do
    url "https://rubygems.org/gems/faraday-multipart-1.0.4.gem"
    sha256 "9012021ab57790f7d712f590b48d5f948b19b43cfa11ca83e6459f06090b0725"
  end

  resource "faraday-net_http" do
    url "https://rubygems.org/gems/faraday-net_http-1.0.1.gem"
    sha256 "3245ce406ebb77b40e17a77bfa66191dda04be2fd4e13a78d8a4305854d328ba"
  end

  resource "faraday-net_http_persistent" do
    url "https://rubygems.org/gems/faraday-net_http_persistent-1.2.0.gem"
    sha256 "0b0cbc8f03dab943c3e1cc58d8b7beb142d9df068b39c718cd83e39260348335"
  end

  resource "faraday-patron" do
    url "https://rubygems.org/gems/faraday-patron-1.0.0.gem"
    sha256 "dc2cd7b340bb3cc8e36bcb9e6e7eff43d134b6d526d5f3429c7a7680ddd38fa7"
  end

  resource "faraday-rack" do
    url "https://rubygems.org/gems/faraday-rack-1.0.0.gem"
    sha256 "ef60ec969a2bb95b8dbf24400155aee64a00fc8ba6c6a4d3968562bcc92328c0"
  end

  resource "faraday-retry" do
    url "https://rubygems.org/gems/faraday-retry-1.0.3.gem"
    sha256 "add154f4f399243cbe070806ed41b96906942e7f5259bb1fe6daf2ec8f497194"
  end

  resource "faraday_middleware" do
    url "https://rubygems.org/gems/faraday_middleware-1.2.0.gem"
    sha256 "ded15d574d50e92bd04448d5566913af5cb1a01b2fa311ceecc2464fa0ab88af"
  end

  resource "gh" do
    url "https://rubygems.org/gems/gh-0.18.0.gem"
    sha256 "eb93f18a88db3ba92eb888610fc53fae731d9dacfe55922b58cc3f3aca776a47"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.3.gem"
    sha256 "2ddd5c127d4692721486f91737307236fe005352d12a4202e26c48614f719479"
  end

  resource "i18n" do
    url "https://rubygems.org/gems/i18n-1.12.0.gem"
    sha256 "91e3cc1b97616d308707eedee413d82ee021d751c918661fb82152793e64aced"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.6.2.gem"
    sha256 "940dc787e33d7e846898724331c9463fd89b54602ff5ed6561f3eaed4168657a"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-2.6.2.gem"
    sha256 "ccf59aeb76249a17d894f0a974073d1264645528f0799a59c52b01560da3a811"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.4.3.gem"
    sha256 "42f52ce12c6fe079bac8a804c66522a0eefe176b845a62df829defe0e37214a4"
  end

  resource "minitest" do
    url "https://rubygems.org/gems/minitest-5.16.2.gem"
    sha256 "c1be0c6b57fab451faa08e74ffa71e7d6a259b90f4bacb881c7f4808ec8b4991"
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.15.0.gem"
    sha256 "1fd04138b6e4a90017e8d1b804c039031399866ff3fbabb7822aea367c78615d"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.2.3.gem"
    sha256 "462979de2971b8df33c2ee797fd497731617241f9dcd93960cc3caccb2dd13d8"
  end

  resource "net-http-persistent" do
    url "https://rubygems.org/gems/net-http-persistent-2.9.4.gem"
    sha256 "24274d207ffe66222ef70c78a052c7ea6e66b4ff21e2e8a99e3335d095822ef9"
  end

  resource "net-http-pipeline" do
    url "https://rubygems.org/gems/net-http-pipeline-1.0.1.gem"
    sha256 "6923ce2f28bfde589a9f385e999395eead48ccfe4376d4a85d9a77e8c7f0b22f"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.7.gem"
    sha256 "8be161e2421f8d45b0098c042c06486789731ea93dc3a896d30554ee38b573b8"
  end

  resource "pusher-client" do
    url "https://rubygems.org/gems/pusher-client-0.6.2.gem"
    sha256 "c405c931090e126c056d99f6b69a01b1bcb6cbfdde02389c93e7d547c6efd5a3"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "thread_safe" do
    url "https://rubygems.org/gems/thread_safe-0.3.6.gem"
    sha256 "9ed7072821b51c57e8d6b7011a8e282e25aeea3a4065eab326e43f66f063b05a"
  end

  resource "tzinfo" do
    url "https://rubygems.org/gems/tzinfo-1.2.10.gem"
    sha256 "c6d3fa6e6de19744171536dc1bd1142442f3f265efabe8d9f28c03f9874f8867"
  end

  resource "websocket" do
    url "https://rubygems.org/gems/websocket-1.2.9.gem"
    sha256 "884b12dee993217795bb5f58acc89c0121c88bdc99df4d1636c0505dca352b36"
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
    (libexec/"gems/travis-#{version}/assets/notifications/Travis CI.app").rmtree
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
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
