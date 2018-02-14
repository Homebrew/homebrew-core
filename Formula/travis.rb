class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/v1.8.8.tar.gz"
  sha256 "468158ee2b46c67c1a002a237a9e04472b22e8f4926cb68b1ca49a1a0b2eaf3b"
  revision 2

  bottle do
    sha256 "d25cfab9d040ecce4189e64702aa9d36ddf1511756b57169bc80d2108222d5ce" => :high_sierra
    sha256 "68f77abeb97763869ce3be363ae0686d193b430c991ea2c3e707abb08cb51085" => :sierra
    sha256 "d8c659ce5703747df3894c8823032a77c438d3641e94374aae51f0e707ecef49" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.4.0.gem"
    sha256 "7abfff765571b0a73549c9a9d2f7e143979cd0c252f7fa4c81e7102a973ef656"
  end

  resource "backports" do
    url "https://rubygems.org/gems/backports-3.10.3.gem"
    sha256 "c027ad53e842fecf8334c6fba40886c3dd0465bcd94a908c262964378798faa9"
  end

  resource "ethon" do
    url "https://rubygems.org/gems/ethon-0.11.0.gem"
    sha256 "88ec7960a8e00f76afc96ed15dcc8be0cb515f963fe3bb1d4e0b5c51f9d7e078"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.13.1.gem"
    sha256 "1c82a788fb827fb4c01766e0777ed8044856f92f8824b7e3e6d663ba8fd4d8bf"
  end

  resource "faraday_middleware" do
    url "https://rubygems.org/gems/faraday_middleware-0.12.2.gem"
    sha256 "2d90093c18c23e7f5a6f602ed3114d2c62abc3f7f959dd3046745b24a863f1dc"
  end

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.9.18.gem"
    sha256 "a0df16d6a369a3306dd257adcb2ddef673e91b9740d0c5f77a98fde3ba288e0c"
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
    url "https://rubygems.org/gems/multi_json-1.12.2.gem"
    sha256 "5dcc0b569969f3d1658c68b5d597fcdc1fc3a34d4ae92b4615c740d95aaa51e5"
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
    url "https://rubygems.org/gems/websocket-1.2.5.gem"
    sha256 "c9de8b82226f9b4647522a9c73be4a1cd60b166b103c993717f94277cb453228"
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
