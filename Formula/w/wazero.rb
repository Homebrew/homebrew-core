class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "218f6a72a9c78df54cfe44b666b97192e2139cf017a235029ca7babc7f4ba9ba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6c11561e03656912639be755a9c0008037a48077a8a8fe9302f2dbd50976591"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4962f4cb3e2c9a1eee0efad83e9a326e11f64cd554ee776853091bd6f8d70334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27dddedea2d0c2e10926bf699683e2b6d22d7cee3ba395bb6efb605adc46c3e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f635fe5eaff6f12c35b7ffff5614f6636ef94e6bcc8d5f97d4086a9b95b8f523"
    sha256 cellar: :any_skip_relocation, ventura:        "190346d9d24b45e8859f52226379850c39e42edf1822ed3df5b1acf8aeb59db4"
    sha256 cellar: :any_skip_relocation, monterey:       "64278a390d773979c6cbd63a72bbd0085c46b150504b06a364d2521e6ce3299d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f947dd8cb421c4112bc260080f3e221bc99c639162975b39d09831a625c4b7d4"
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
