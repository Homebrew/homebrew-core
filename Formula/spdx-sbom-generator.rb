class SpdxSbomGenerator < Formula
  desc "Support CI generation of SBOMs via golang tooling"
  homepage "https://github.com/spdx/spdx-sbom-generator"
  url "https://github.com/spdx/spdx-sbom-generator/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "7d088f136a53d1f608b1941362c568d78cc6279df9c1bdb3516de075cb7f10c3"
  license any_of: ["Apache-2.0", "CC-BY-4.0"]

  depends_on "go" => [:build, :test]

  def install
    target = if Hardware::CPU.arm?
      "build-mac-arm64"
    elsif OS.mac?
      "build-mac"
    else
      "build"
    end

    system "make", target

    bin.install "bin/spdx-sbom-generator"
  end

  test do
    system "go", "mod", "init", "example.com/tester"

    assert_equal "panic: runtime error: index out of range [0] with length 0",
                 shell_output("#{bin}/spdx-sbom-generator 2>&1", 2).split("\n")[3]
  end
end
