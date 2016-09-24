class Tutum < Formula
  desc "Docker platform for dev and ops"
  homepage "https://www.tutum.co/"
  url "https://github.com/tutumcloud/cli/archive/v0.21.1.tar.gz"
  sha256 "868ee3b085fd271e163b27a28cc45c1a8d290e95094f4128206b9b55bddecb09"

  bottle do
    cellar :any_skip_relocation
    sha256 "59d67147fbcbe56b851f158dda7551f2539ca0a97176f4fbdfb2699458806d5a" => :el_capitan
    sha256 "47976d0e8099d0b4f35e809aaf1187656116e6ba1914bb9c22a9f220c08a493f" => :yosemite
    sha256 "160d6e3eaeea07efd2f629c92e90754bfe112122b01fb1e7a2312bf4dc0d19d0" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ago" do
    url "https://files.pythonhosted.org/packages/24/24/00a3e8d9a263091e695fad26e4090d1e9cab1ee5f3fd2ab698a19b9b4539/ago-0.0.6.tar.gz"
    sha256 "a64811a5a44cd3ba687d800986edf0f7a97859b8da75d3347c915b58b0869b44"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/3a/15/f9e48bfd2b971ade10ad0c03babab057791c260b05322cbd3f47e27be108/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/b3/d3/095ce5c860d6c39a97d51379d67643a2277b07191fe3d37ddae0f419dfe0/docker-py-1.2.3.tar.gz"
    sha256 "5328a7f4a2d812da166b3fb59211fca976c9f48bb9f8b17d9f3fd4ef7c765ac5"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/7c/eb/1d7403c6d187ec097394685b0ea8a69faadaeb63f222d6c9b85ae165f915/future-0.15.0.tar.gz"
    sha256 "7f8ad46e287ac32e3dae78be41098c83d690b364142e0a5f11958c2b549420b0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/b6/ff/5eaa688dd8ce78913f47438f9b40071a560126ac3e95f9b9be27dfe546a7/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "python-tutum" do
    url "https://files.pythonhosted.org/packages/5c/29/1182449c335f8994e01109990ca8339337078e5b397fd20318b095fb38e5/python-tutum-0.21.1.tar.gz"
    sha256 "eea1a87262b8ac75f3e24d9b828c8b9aa393d766c5a61ae15ac8a5393e1260a0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/00/17/3b822893a1789a025d3f676a381338516a8f65e686d915b0834ecc9b4979/PyYAML-3.10.tar.gz"
    sha256 "e713da45c96ca53a3a8b48140d4120374db622df16ab71759c9ceb5b8d46fe7c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/0a/00/8cc925deac3a87046a4148d7846b571cf433515872b5430de4cd9dea83cb/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/64/1dc5e5976b17466fd7d712e59cbe9fb1e18bec153109e5ba3ed6c9102f1a/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/2f/7d/f138a03594eeaf9aaef8c3d7923f70cfd1f4dfc774bedd46cbcc7ddf71c4/tabulate-0.7.2.tar.gz"
    sha256 "532ccab8d9e4659a5f016d84814df86cc04763785e9de2739e890d956dc82d8f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/f4/06/5552e64fee863aa9decbb4e46dccc05fe730a36f49f0d6427398837297da/websocket_client-0.32.0.tar.gz"
    sha256 "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/tutum", "container"
  end
end
