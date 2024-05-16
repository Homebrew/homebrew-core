# typed: false
# frozen_string_literal: true

class Regit < Formula
  desc "CLI tool to manage git repositories and histories"
  homepage "https://github.com/woaitsAryan/regit"
  url "https://github.com/woaitsAryan/regit/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "862e1e9ce7f96bc191270e1bb232fdb6d36e397edd16c70cb63f9816ae14742a"
  license "MIT"
  depends_on "go" => :build
  depends_on "git-filter-repo"

  def install
    system "go", "build", "-o", "#{bin}/regit", "."
  end

  def caveats
    <<~EOS
      Just run the command by typing regit, the help menu will assist you
    EOS
  end

  test do
    system "#{bin}/regit", "help"
  end
end
