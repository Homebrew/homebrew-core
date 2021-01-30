class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git"

  stable do
    url "https://github.com/tfutils/tfenv/archive/v2.1.0.tar.gz"
    sha256 "f8f1e14e1d5064c47ddbb041e31ce15ac0a849e620541598db09efff575b3c9b"

    # fix bash 3.x compatibility
    # removed in the next release
    # Original source: "https://github.com/tfutils/tfenv/pull/181.patch?full_index=1"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/526faca9830646b974f563532fa27a1515e51ca1/tfenv/2.0.0.patch"
      sha256 "b1365be51a8310a44b330f9b008dabcdfe2d16b0349f38988e7a24bcef6cae09"
    end
  end

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  uses_from_macos "unzip"

  conflicts_with "terraform", because: "tfenv symlinks terraform binaries"

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/tfenv list-remote")
  end
end
