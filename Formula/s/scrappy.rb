class Scrappy < Formula
  desc "Python utility for scraping manuals, documents, and other sensitive PDFs"
  homepage "https://github.com/RoseSecurity/ScrapPY"
  url "https://github.com/RoseSecurity/ScrapPY/archive/refs/tags/0.1.0.tar.gz"
  sha256 "db8b1fcf0318aad469cb41989d9455fa7c4d088800b9830e4f0a7f0c8bb5684e"
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
