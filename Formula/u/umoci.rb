# typed: false
# frozen_string_literal: true

class Umoci < Formula
  desc "Reference OCI implementation for creating, modifying and inspecting images"
  homepage "https://github.com/opencontainers/umoci"
  url "https://github.com/opencontainers/umoci/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "400a26c5f7ac06e40af907255e0e23407237d950e78e8d7c9043a1ad46da9ae5"
  license "Apache-2.0"

  depends_on "go"          => :build
  depends_on "go-md2man"   => :build
  depends_on "gpgme"

  def install
    # Build the binary
    system "go", "build",
           "-mod=vendor",
           "-trimpath",
           "-o", bin/"umoci",
           "./cmd/umoci"

    # Build the man page(s)
    man_dir = buildpath/"docs/man"
    man_dir.mkpath

    Dir["#{buildpath}/doc/man/*.md"].each do |md|
      name = File.basename(md, ".md")
      system "go-md2man", "-in=#{md}", "-out=#{man_dir}/#{name}.1"
    end

    man1.install Dir["#{man_dir}/*.1"]
  end

  def caveats
    <<~EOS
      umoci is now installed as the executable `umoci`.
      Shell completions for Bash, Zsh and Fish have been installed.

      Example:
        umoci --help
    EOS
  end

  test do
    output = shell_output("#{bin}/umoci version")
    assert_match "umoci version #{version}", output

    (testpath/"empty").mkpath
    error = shell_output("#{bin}/umoci unpack --image empty:nonexistent #{testpath}/out 2>&1", 1)
    assert_match "no such file or directory", error
  end
end
