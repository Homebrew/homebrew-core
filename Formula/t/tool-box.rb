# frozen_string_literal: true

class ToolBox < Formula
  desc "Offline web-based toolkit with 27 utilities"
  homepage "https://github.com/abczzy2011-lab/toolbox"
  url "https://github.com/abczzy2011-lab/toolbox/releases/download/v1.0.4/toolbox.zip"
  sha256 "d697c2f5a6fcc04f68cc75aeef3692cf7c20bf357da7df0f07d1d69317e178f4"
  license "MIT"

  def install
    prefix.install buildpath.children
    libexec.install "tool-box"
    bin.write_exec_script libexec/"tool-box"
  end

  test do
    output = shell_output("#{bin}/tool-box ip")
    assert_match(%r{http://\d+\.\d+\.\d+\.\d+:\d+}, output)
  end
end