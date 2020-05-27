class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v2.0.0.tar.gz"
  sha256 "de3dcf13768cb078e94d68ca85071b8d6e44104394336d952255ca558b854b0b"
  head "https://github.com/tfutils/tfenv.git"

  bottle :unneeded

  uses_from_macos "unzip"

  conflicts_with "terraform", :because => "tfenv symlinks terraform binaries"

  # fix bash 3.x compatibility
  # removed in the next release
  unless build.head?
    patch do
      url "https://github.com/tfutils/tfenv/pull/181.patch?full_index=1"
      sha256 "b1365be51a8310a44b330f9b008dabcdfe2d16b0349f38988e7a24bcef6cae09"
    end
  end

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    system bin/"tfenv", "list-remote"
  end
end
