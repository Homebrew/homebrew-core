class Restview < Formula
  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://github.com/mgedmin/restview/archive/2.9.2.tar.gz"
  sha256 "155a5744111d3d1f9e7903f4445ff41c04b42c0be29705f57fb98b3d33b283bd"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4604570163a307b9c8f0650d4f659cf985bc52260a653c3659ad22ca28e96769" => :catalina
    sha256 "83b3b6d66d30c2d5362cb6418b41bee11b86940bac91aeab6e2d2e558560d87e" => :mojave
    sha256 "776a2d539bfcaa95f2ff94db1aafe9e5a7817341b5484ea253f667a8f7538ec3" => :high_sierra
  end

  depends_on "python"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/eb/ea/58428609442130dc31d3a59010bf6cbd263a16c589d01d23b7c1e6997e3b/bleach-2.1.3.tar.gz"
    sha256 "eb7386f632349d10d9ce9d4a838b134d4731571851149f9cc2c05a9a837a9a44"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "cmarkgfm" do
    url "https://files.pythonhosted.org/packages/e2/a3/4021fbc17c5afe7f307d14eba0d6899a8e66b351ab65649b1c89c50a836d/cmarkgfm-0.4.2.tar.gz"
    sha256 "f20900f16377f2109783ae9348d34bc80530808439591c3d3df73d5c7ef1a00c"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "readme_renderer" do
    url "https://files.pythonhosted.org/packages/c8/aa/4b98370d8a5af38d2f9b75660e1240fa6f686fac4daae22a4172467d5574/readme_renderer-20.0.tar.gz"
    sha256 "bde909eaa84d65b7942f7e6998c8b427b90b568b2630ff0306f4ca75f6d2a909"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "sample" do
    url "https://raw.githubusercontent.com/mgedmin/restview/140e23ad6604d52604bc11978fd13d3199150862/sample.rst"
    sha256 "5a15b5f11adfdd5f895aa2e1da377c8d8d0b73565fe68f51e01399af05612ea3"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    res = resources.reject { |r| r.name == "sample" }

    res.each do |r|
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
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    testpath.install resource("sample")

    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 1
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end
