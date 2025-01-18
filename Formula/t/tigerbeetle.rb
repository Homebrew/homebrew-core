class Tigerbeetle < Formula
  desc "Financial transactions database"
  homepage "https://tigerbeetle.com"
  url "https://github.com/tigerbeetle/tigerbeetle.git",
      tag:      "0.16.21",
      revision: "1315c3e5abdea32812695ba4feeceee68cada365"
  license "Apache-2.0"

  depends_on "zig" => :build
  on_macos do
    depends_on "llvm" # Required for llvm-objcopy
  end

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
    ]

    args << "-Dllvm-objcopy=#{Formula["llvm"].opt_bin/"llvm-objcopy"}" if OS.mac?
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    system bin/"tigerbeetle format --cluster=0 --replica=0 --replica-count=1 --development 0_0.tigerbeetle"
    assert_predicate testpath/"0_0.tigerbeetle", :exist?
  end
end
