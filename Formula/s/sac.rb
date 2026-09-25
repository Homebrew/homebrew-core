class Sac < Formula
  desc "Seismic Analysis Code, Community Edition"
  homepage "https://github.com/EarthScope/sac-community"
  url "https://github.com/EarthScope/sac-community/archive/refs/tags/v103.0.tar.gz"
  sha256 "f61fbe30d0411fe3033bdb76731062da24940c27920338d0f91a867842b791b8"
  license "Apache-2.0"

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxpm"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  deny_network_access!

  def install
    args = %W[
      --x-includes=#{formula_opt_include("libx11")}
      --x-libraries=#{formula_opt_lib("libx11")}
    ]

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    libexec.install bin/"sac"
    (bin/"sac").write_env_script libexec/"sac", SACAUX: "#{opt_prefix}/aux", SACHOME: opt_prefix

    # The environment scripts are meant to be sourced and have no shebang, so
    # they are not executables and do not belong in bin.
    pkgshare.install bin/"sacinit.sh", bin/"sacinit.csh"

    # Upstream generates them with the versioned keg path baked in; use the
    # stable `opt` prefix instead so that a copy does not go stale on upgrade.

    rm lib/"README_lib"
  end

  def caveats
    <<~EOS
      Configuration scripts live in: #{opt_pkgshare}
    EOS
  end

  test do
    (testpath/"commands.m").write <<~EOS
      fg impulse npts 100 delta 0.01
      w test.sac
      quit
    EOS

    system bin/"sac", "commands.m"
    assert_equal %w[test.sac 0.01 100], shell_output("#{bin}/saclst delta npts f test.sac").split
  end
end
