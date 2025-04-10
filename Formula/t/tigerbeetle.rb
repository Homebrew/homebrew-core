class Tigerbeetle < Formula
  desc "Financial transactions database"
  homepage "https://tigerbeetle.com"
  url "https://github.com/tigerbeetle/tigerbeetle.git",
      tag:      "0.16.27",
      revision: "1c7db9310d65ef9b8dcef61431cd4d8b6da95459"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  depends_on "zig" => :build

  on_linux do
    depends_on "liburing"
  end

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Drelease
      -Dconfig-release=#{version}
      -Dconfig-release-client-min=0.15.3
    ]

    if OS.mac?
      # Help zig find libc from the MacOS SDK
      (buildpath/"zig_libc.txt").write <<~EOS
        include_dir=#{MacOS.sdk_path}/usr/include/
        sys_include_dir=#{MacOS.sdk_path}/usr/include/
        crt_dir=#{MacOS.sdk_path}/usr/lib/
        msvc_lib_dir=
        kernel32_lib_dir=
        gcc_dir=
      EOS

      macos_args = %W[
        --libc #{buildpath}/zig_libc.txt
        --sysroot #{MacOS.sdk_path}
      ]
    end

    system "zig", "build", *args, *macos_args
  end

  test do
    assert_match "TigerBeetle version #{version}", shell_output("#{bin}/tigerbeetle version")

    # Fails in Linux CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"tigerbeetle format --cluster=1 --replica=0 --replica-count=1 --development 1_1.tigerbeetle"
    assert_predicate testpath/"1_1.tigerbeetle", :exist?
  end
end
