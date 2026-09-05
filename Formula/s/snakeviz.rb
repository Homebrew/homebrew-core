class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "542d2b03bfee2f7f621a6c31778d97644f5f322d5fc19313017bea67402c480b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110b4e7ef8233d3c9d6b917563258191aa498c1c85892507443cd2e1d8f4ddb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0df43e7198a8209d43b2d96d48ba69677da9195f3e15a38422be9aee51d9c30"
    sha256 cellar: :any,                 arm64_linux:   "3f6067205d54969dd9d708c177f39f6b291511649a483e23aed3adea36fc5581"
    sha256 cellar: :any,                 x86_64_linux:  "f596c4650cb14ddeab65fefb4470480d767e7fc5609203b7d1274952ad0f1fc7"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/10/d3/343e5bb989d6515b1646cf3d40135d73f3d5e45339bded401b56cdac24dd/tornado-6.5.8.tar.gz"
    sha256 "9452e1b208a8bd771e2cb1f2ff564985b9b214bdebbe622793e1799e0a6bd23f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system bin/"snakeviz", "--version"
    system python3, "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

    port = free_port

    output_file = testpath/"output.prof"

    pid = fork do
      exec bin/"snakeviz", "--port", port.to_s, "--server", output_file
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{ERB::Util.url_encode output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end
