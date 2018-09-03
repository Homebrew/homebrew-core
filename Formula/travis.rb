class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/v1.8.9.tar.gz"
  sha256 "7a143bd0eb90e825370c808d38b70cca8c399c68bea8138442f40f09b6bbafc4"
  revision 1

  bottle do
    cellar :any
    sha256 "6338b2e199cb6ae30c29c02384f8269602d11842685c007ecd7d47932c02d2e5" => :mojave
    sha256 "a85b312df0e6d91c3cf3ce5a935b53b193e3e60dfbfcf0592427d5f976b4220b" => :high_sierra
    sha256 "5244d9146eb622169744fb10f7e3e3e529b1d2bb9aab13f98dc97de6b564315c" => :sierra
    sha256 "fce097e64f335bd69ea49b3025aebb904db15bcb7f2599b8e0e5beb0de427e9e" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :sierra

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.4.0.gem"
    sha256 "7abfff765571b0a73549c9a9d2f7e143979cd0c252f7fa4c81e7102a973ef656"
  end

  resource "backports" do
    url "https://rubygems.org/gems/backports-3.11.3.gem"
    sha256 "57b04d4e2806c199bff3663d810db25e019cf88c42cacc0edbb36d3038d6a5ab"
  end

  resource "ethon" do
    url "https://rubygems.org/gems/ethon-0.11.0.gem"
    sha256 "88ec7960a8e00f76afc96ed15dcc8be0cb515f963fe3bb1d4e0b5c51f9d7e078"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.15.2.gem"
    sha256 "affa23f5e5ee27170cbb5045c580af9b396bac525516c6583661c2bb08038f92"
  end

  resource "faraday_middleware" do
    url "https://rubygems.org/gems/faraday_middleware-0.12.2.gem"
    sha256 "2d90093c18c23e7f5a6f602ed3114d2c62abc3f7f959dd3046745b24a863f1dc"
  end

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.9.25.gem"
    sha256 "f854f08f08190fec772a12e863f33761d02ad3efea3c3afcdeffc8a06313f54a"
  end

  resource "gh" do
    url "https://rubygems.org/gems/gh-0.15.1.gem"
    sha256 "ef733f81c17846f217f5ad9616105e9adc337775d41de1cc330133ad25708d3c"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.7.10.gem"
    sha256 "1e147d5d20f1ad5b0e23357070d1e6d0904ae9f71c3c49e0234cf682ae3c2b06"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.4.3.gem"
    sha256 "42f52ce12c6fe079bac8a804c66522a0eefe176b845a62df829defe0e37214a4"
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.13.1.gem"
    sha256 "db8613c039b9501e6b2fb85efe4feabb02f55c3365bae52bba35381b89c780e6"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.0.0.gem"
    sha256 "3dc44e50d3df3d42da2b86272c568fd7b75c928d8af3cc5f9834e2e5d9586026"
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
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
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

      sudo: true

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
