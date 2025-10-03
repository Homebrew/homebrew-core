class Yh < Formula
  desc "YAML syntax highlighter to bring colours where only jq could"
  homepage "https://github.com/andreazorzetto/yh"
  url "https://github.com/andreazorzetto/yh/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "78ef799c500c00164ea05aacafc5c34dccc565e364285f05636c920c2c356d73"
  license "Apache-2.0"
  head "https://github.com/andreazorzetto/yh.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e86e1650543e20f82c853e9f33f44dfa71ff7856fed04e03d9b40db36991546a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "37b637b99befa6608662694e5100828cf4ad50a9513e57cae75febfd04e9fc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4719f7e1a8166248cf84ac5efe7d8bf0df277a08ed4cba8e1b071f87622dfb67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "676027b73d92187c5394037264a16c8b1e5c175e0619db4d26b4eef92ea224d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d48312b6e67ee8a4bd548dcbb392a296310bc7100cda5072fdd85cf700defc87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c7d591013f9ba22f605f81f1f058c3377f4125ef1d0f990651e9cdd12805cdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a65aaf84b0fb6c01d149ac73bc527f00317c716f472b650d3d1515b0ae5fa71"
    sha256 cellar: :any_skip_relocation, ventura:        "26c0d39a156eb0dfe843e5fe5a70ff7d6e83caa2198fcb6b9f9c859829504ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "ea039f653c085836860511f1f626f9d9be4848b455b7019f8a52556721cfbfe0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8165967a843d90d96ed71a41b303b7b434cf855e1e456d428c694aeceeee737"
    sha256 cellar: :any_skip_relocation, catalina:       "1a2425d399a63df18758dfabf9d50da2559fb489c32bfb4462d7437f64fc0817"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a31f46802b6d13d9e654ceef943f861c8c06d44a5c92385df91f942f0e610d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d24c1a925e08cc62ccb741d0587e59fb79c76a34b4b5b23599c51fa58ad6dd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "\e[91mfoo\e[0m: \e[33mbar\e[0m\n", pipe_output(bin/"yh", "foo: bar")
  end
end
