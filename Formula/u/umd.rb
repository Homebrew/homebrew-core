# typed: false
# frozen_string_literal: true

class Umd < Formula
  include Language::Python::Virtualenv

  desc "Powerful, feature-rich media downloader supporting 1000+ platforms"
  homepage "https://github.com/NK2552003/ULTIMATE-MEDIA-DOWNLOADER"
  url "https://github.com/NK2552003/ULTIMATE-MEDIA-DOWNLOADER/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "b340d9177ff79cacd38e46a281d43c0e7939d5dfe24441cfabe6d013db607553"
  license "Apache-2.0"
  head "https://github.com/NK2552003/ULTIMATE-MEDIA-DOWNLOADER.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # curl-cffi wheels sometimes build from source
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "openssl@3"
  depends_on "pipx"
  depends_on "python@3.12"

  def install
    pybin = Formula["python@3.12"].opt_bin
    ENV.prepend_path "PATH", pybin
    ENV["PIPX_HOME"] = libexec/"pipx"
    ENV["PIPX_BIN_DIR"] = bin
    ENV["PIPX_DEFAULT_PYTHON"] = (pybin/"python3.12").to_s
    ENV.append "LDFLAGS", "-Wl,-headerpad_max_install_names"

    pip_args = "--no-binary pydantic-core"
    spec = "git+https://github.com/NK2552003/ULTIMATE-MEDIA-DOWNLOADER.git@main#egg=ultimate-downloader"

    system "pipx", "install",
           "--python", pybin/"python3.12",
           "--pip-args=#{pip_args}",
           "--force",
           spec
  end

  def caveats
    <<~EOS
      The `umd` command is installed into:
        #{opt_bin}

      Downloads default to ~/Downloads/UltimateDownloader.
      Update with: brew reinstall #{name} (or brew upgrade if already installed).
    EOS
  end

  test do
    system bin/"umd", "--help"
  end
end
