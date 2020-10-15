class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git"

  stable do
    url "https://github.com/tfutils/tfenv/archive/v2.0.0.tar.gz"
    sha256 "de3dcf13768cb078e94d68ca85071b8d6e44104394336d952255ca558b854b0b"

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
