class Scrappy < Formula
  desc "Python utility for scraping manuals, documents, and other sensitive PDFs"
  homepage "https://github.com/RoseSecurity/ScrapPY"
  url "https://github.com/RoseSecurity/ScrapPY/archive/refs/tags/0.1.0.tar.gz"
  sha256 "716d4e798b99286ca007903760ad0a70a40960b3fedc62e6bcdd739784a1a0c7"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/ScrapPY.git", branch: "main"

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    system "python3", "ScrapPY.py", "-h"
    output = shell_output("python3 ScrapPY.py -h")
    assert_match "usage", output
  end
end
