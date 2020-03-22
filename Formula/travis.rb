class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/v1.8.11.tar.gz"
  sha256 "f69f71f7634c1495c516f820571bdeec2e759c617ecaf9c83b3bf478ceb54cd4"

  bottle do
    sha256 "0b374c59a0c5fe2de8c14f11c1d6e20513d889eed4b884ef887066b441f26453" => :catalina
    sha256 "286b2c03f76017b47eecf7e0e7942f17f9ce34af0ba1a553d18d2666d51fac41" => :mojave
    sha256 "9628e3997873674ca6cbd06cb4421b4f2816499706d472d16695c1f7a25a8ab3" => :high_sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  uses_from_macos "libffi"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.4.0.gem"
    sha256 "7abfff765571b0a73549c9a9d2f7e143979cd0c252f7fa4c81e7102a973ef656"
  end

  resource "backports" do
    url "https://rubygems.org/gems/backports-3.17.0.gem"
    sha256 "bb18a4c7a2a13828d18e348ea81183554adcaac4fc9db0ecd1f3d1dfbd7fdc8f"
  end

  resource "ethon" do
    url "https://rubygems.org/gems/ethon-0.11.0.gem"
    sha256 "88ec7960a8e00f76afc96ed15dcc8be0cb515f963fe3bb1d4e0b5c51f9d7e078"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.9.2.gem"
    sha256 "0662e5caa257c256cff4b073deef5c73e3469d3ed0b8d6e9a05e6861efc4f4ce"
  end

  resource "faraday_middleware" do
    url "https://rubygems.org/gems/faraday_middleware-0.9.2.gem"
    sha256 "15d1e22157e8a0704ae7ac0156e12304368c1695f009c292b28a034d49824ad4"
  end

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.9.25.gem"
    sha256 "f854f08f08190fec772a12e863f33761d02ad3efea3c3afcdeffc8a06313f54a"
  end

  resource "gh" do
    url "https://rubygems.org/gems/gh-0.13.3.gem"
    sha256 "0857f24464dbcdaa71a43c34f21fce77faf5bf661a3b6a903739c82ab1884fa8"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.6.21.gem"
    sha256 "c136298eee86ceff87baadc71d764ea07986f89805636e4a6a305b2d5da07519"
  end

  if MacOS.version <= :sierra
    resource "json" do
      url "https://rubygems.org/gems/json-2.1.0.gem"
      sha256 "b76fd09b881088c6c64a12721a1528f2f747a1c2ee52fab4c1f60db8af946607"
    end
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.1.2.gem"
    sha256 "5a47c249e18fcd46a093210530e68911ab595575aa69d16e3613f740bcc50d2c"
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
