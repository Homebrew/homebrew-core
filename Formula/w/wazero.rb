class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "43a8445929286ab4b833f76de82fabceba898ffcd999f9c4374b215998e659e7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e8a4f58eff1ee08e608303ee9f27ba919a6b15fce127798ede6a2db52d40e0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc55a7c33008730607f639164d698323ad78fd74a8bddae220f7dad42ee54b2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51d14f2adbbb5a5068f7032ace3968f41835a23918e1977bd48f186d89a0dc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "17d4277bd7da254b9754978f08bdeeacf81bcd2f4d57e8802708d66d1dc587f0"
    sha256 cellar: :any_skip_relocation, ventura:        "70e822ddcfe3fbe8d30370362658e74a70b2797f79897cc53de055e392428e5e"
    sha256 cellar: :any_skip_relocation, monterey:       "8d5d94d1a933056d0687675b95c6a67c123ab5b5940c2e5eef14e22d838f4836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "582cd5a0a049072d47958b79339ce515e7cbfcfb455ca61f4c15777d2d119b1f"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wazero"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/wazero version").chomp

    (testpath/"mount.wat").write <<~EOS
      ;; print the preopen directory path (guest side of the mount).
      (module
        (import "wasi_snapshot_preview1" "fd_prestat_get"
          (func $wasi.fd_prestat_get (param i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_prestat_dir_name"
          (func $wasi.fd_prestat_dir_name (param i32 i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_write"
          (func $wasi.fd_write (param i32 i32 i32 i32) (result i32)))

        (memory (export "memory") 1 1)

        (func $main (export "_start")
          ;; First, we need to know the size of the prestat dir name.
          (call $wasi.fd_prestat_get
            (i32.const 3) ;; preopen FD
            (i32.const 0)) ;; where to write prestat
          (drop) ;; ignore the errno returned

          ;; Next, write the dir name to offset 8 (past the prestat).
          (call $wasi.fd_prestat_dir_name
            (i32.const 3) ;; preopen FD
            (i32.const 8) ;; where to write dir_name
            (i32.load (i32.const 4))) ;; length is the last part of the prestat
          (drop) ;; ignore the errno returned

          ;; Now, convert the prestat to an iovec [offset, len] writing offset=8.
          (i32.store (i32.const 0) (i32.const 8))

          ;; Finally, copy the dirname to stdout via its iovec [offset, len].
          (call $wasi.fd_write
            (i32.const 1) ;; stdout
            (i32.const 0) ;; where's the iovec
            (i32.const 1) ;; only one iovec
            (i32.const 0)) ;; overwrite the iovec with the ignored result.
          (drop) ;; ignore the errno returned
        )
      )
    EOS

    system "wat2wasm", testpath/"mount.wat", "-o", testpath/"mount.wasm"

    assert_equal "/homebrew",
      shell_output("#{bin}/wazero run -mount=/tmp:/homebrew #{testpath/"mount.wasm"}")
  end
end
