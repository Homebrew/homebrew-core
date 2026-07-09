class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b8e872a15582ff11b19520eb698aaf5ca1eac2d3a2f033c5de9cd9ceb60c816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cdb77ff8257e9df7872f7e4fcdaa03cfbd30ad54102b520fcac3c199d530089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25ebdfb0bb4eea6d6120825b306ba2c46d9fee10955639406d332dd12a439f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "424c0e0788fd9d8251830bcf8cfb9ce55f7aad2379ce5a020e2924d4a351d1e3"
    sha256 cellar: :any,                 arm64_linux:   "d479a7bc600cde0dc3ac21025d4c4132621e915d28635be7a28de4a6a81c6fa3"
    sha256 cellar: :any,                 x86_64_linux:  "ccf9b3189e1b18e2275cf4f53823c2f32e5100aa95187f85a185866d6a4ef5a2"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/24/95ec527ad67b76d59299e5465b3935d05e4294b7e0290a3924b7487df30b/tornado-6.5.7.tar.gz"
    sha256 "66c513a76cda70d53907bc27cf1447557699c2e95aa48ba27a442ff61c3ddfc2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system bin/"snakeviz", "--version"
    system "python3.14", "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

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
