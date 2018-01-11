class Twtxt < Formula
  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://github.com/buckket/twtxt/archive/v1.2.3.tar.gz"
  sha256 "73b9d4988f96cc969c0c50ece0e9df12f7385735db23190e40c0d5e16f7ccd8c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2acd447c2233ff8820270c546b79eb22b3aeb6034dabc58198934115e797e261" => :high_sierra
    sha256 "58c726382f159731b92891a8d19b5860a6d4f057d28856896b4de9343bb86666" => :sierra
    sha256 "7875855c0b5ba87335d6bb76dc900604b215fccce80156eacdbc81b9ee555c8c" => :el_capitan
  end

  depends_on "python3"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/1e/d4/c1206b016b42a0b223aadb559318966b64ec27e5406bed79c36356e62082/aiohttp-2.2.5.tar.gz"
    sha256 "af5bfdd164256118a0a306b3f7046e63207d1f8cba73a67dcc0bd858dcfcd3bc"
  end

  resource "async_timeout" do
    url "https://files.pythonhosted.org/packages/6f/cc/ff80612164fe68bf97767052c5c783a033165df7d47a41ae5c1cc5ea480b/async-timeout-1.4.0.tar.gz"
    sha256 "983891535b1eca6ba82b9df671c8abff53c804fce3fa630058da5bbbda500340"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/68/a6/d241f9d1ed5ca55a819329c2f98c6833a2d8f25463bc03c44039cd13639c/multidict-3.2.0.tar.gz"
    sha256 "e27a7a95317371c15ecda7206f6e8c144f10a337bb2c3e61b5176deafbb88cb2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/26/8b/e335a45600953cbaaa57e7f276eb8d89128898f11de63c47ecb97e32d29e/yarl-0.12.0.tar.gz"
    sha256 "fc0f71ffdce882b4d4b287b0b3a68d9f2557ab14cc2c10ce4df714c42512cbde"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/"config").write <<~EOS
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      twtxt = https://buckket.org/twtxt_news.txt
    EOS
    (testpath/"twtxt.txt").write <<~EOS
      2016-02-05T18:00:56.626750+00:00  Homebrew speaks!
    EOS
    assert_match "Fiat Lux!", shell_output("#{bin}/twtxt -c config timeline")
  end
end
