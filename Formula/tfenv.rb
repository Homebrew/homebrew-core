class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v1.0.2.tar.gz"
  sha256 "5ee33ee80fa850dd7c007d65a0a18bfb35ff2edfaef1e35d92d836941836f42f"
  head "https://github.com/tfutils/tfenv.git"

  bottle :unneeded

  conflicts_with "terraform", :because => "tfenv symlinks terraform binaries"

  def install
    prefix.install ["bin", "libexec", "share"]
    prefix.install "lib" if build.head?
  end

  test do
    system bin/"tfenv", "list-remote"
  end
end
