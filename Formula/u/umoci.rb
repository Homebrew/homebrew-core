class Umoci < Formula
  desc "Reference OCI implementation for creating, modifying and inspecting images"
  homepage "https://github.com/opencontainers/umoci"
  url "https://github.com/opencontainers/umoci/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "400a26c5f7ac06e40af907255e0e23407237d950e78e8d7c9043a1ad46da9ae5"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "gpgme"

  def install
    system "go", "build", "-ldflags=-s -w", "./cmd/umoci"

    bin.install "umoci" => "umoci"

    (buildpath/"docs/man").mkpath
    Dir["doc/man/*.md"].each do |md|
      name    = File.basename(md, ".md")
      target  = buildpath/"docs/man"/(name + ".1")
      system "go-md2man", "-in", md, "-out", target
      man1.install target
    end
  end

  test do
    output = shell_output("#{bin}/umoci version")
    assert_match "umoci version #{version}", output

    (testpath/"empty").mkpath
    assert_match version.to_s, shell_output("#{bin}/umoci version")
  end
end
