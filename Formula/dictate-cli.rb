class DictateCli < Formula
  desc "One-shot CLI for dictate: record, transcribe, and copy to clipboard"
  homepage "https://github.com/tindotdev/dictate"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.0/dictate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1621b0047c93e3531a8bdd42a7614382355c36ddc2ae24b273692d65ab6c0cd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.0/dictate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "00111fdb186bd512a13cb86956586bfa78254fec9b9b7265019b8d41e1264e34"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.0/dictate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f0ad53a62e931912e5b922fc8a47199e8d18fbee9f89375c81cbfde7ccf9a45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.0/dictate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "843094f60764bffaf46cab68c2437a86c1affc33cd62b017b768f9f95ca597ba"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dictate" if OS.mac? && Hardware::CPU.arm?
    bin.install "dictate" if OS.mac? && Hardware::CPU.intel?
    bin.install "dictate" if OS.linux? && Hardware::CPU.arm?
    bin.install "dictate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
