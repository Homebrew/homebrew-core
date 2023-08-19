class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/10/93/20516dada3c64de14305fd8137251cd4accaa7eba15b44deb1f2419aa9ff/restview-3.0.1.tar.gz"
  sha256 "8c1a171c159d46d15d5569f77021828883a121d6f9baf758d641fc1e54b05ae5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7144d1e54ac3ed388b6af07e9d5d4d5c3ab69a7d8335827d436e5d95cd90700"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c41b60a583752a7c15309695cdc0dccccc9f98771cc28d290352863877fadfd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0526020a022a59774f2eb26fbcf5f9422085fce34286004c37e8a74f715ff51"
    sha256 cellar: :any_skip_relocation, ventura:        "5c36b262a3d8898d9caeebc8f9faf3806e2554a3836d430ad2ce985ae389c69d"
    sha256 cellar: :any_skip_relocation, monterey:       "045d7c7fbec94805454c23b54ac749995171610eb9b7e8a39d96f740bd02e44d"
    sha256 cellar: :any_skip_relocation, big_sur:        "41c9ba7729e2494ef67b6158b715b03dbf186e33cd12f9cdf7f35263578ea456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c959a52879a1835bda4c7e8b9e454afc7ac20613a72c31547cfad5264e294991"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/c2/5d/d5d45a38163ede3342d6ac1ca01b5d387329daadf534a25718f9a9ba818c/bleach-5.0.1.tar.gz"
    sha256 "0d03255c47eb9bd2f26aa9bb7f2107732e7e8fe195ca2f64709fcf3b0a4a085c"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/15/4e/0ffa80eb3e0d0fcc0c6b901b36d4faa11c47d10b9a066fdd42f24c7e646a/readme_renderer-36.0.tar.gz"
    sha256 "f71aeef9a588fcbed1f4cc001ba611370e94a0cd27c75b1140537618ec78f0a2"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.rst").write <<~EOS
      Lists
      -----

      Here we have a numbered list

      1. Four
      2. Five
      3. Six
    EOS

    port = free_port
    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 3
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end
