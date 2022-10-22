
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.31.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Test1: Ensure that it increments",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address;

        let block = chain.mineBlock([
            Tx.contractCall("roman-counter", "increment", [], deployer)
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);
        assertEquals(block.receipts[0].result, '(ok {Counter: 1, RomanCounter: "I"})');
    },
});

Clarinet.test({
    name: "Test2: Ensure that it decrements",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address;

        let block = chain.mineBlock([
            Tx.contractCall("roman-counter", "increment", [], deployer),
            Tx.contractCall("roman-counter", "increment", [], deployer),
            Tx.contractCall("roman-counter", "decrement", [], deployer)
        ]);
        assertEquals(block.receipts.length, 3);
        assertEquals(block.height, 2);
        assertEquals(block.receipts[2].result, '(ok {Counter: 1, RomanCounter: "I"})');
    },
});

Clarinet.test({
    name: "Test2: Ensure that it throws an error when the counter get to zero",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!.address;

        let block = chain.mineBlock([
            Tx.contractCall("roman-counter", "increment", [], deployer),
            Tx.contractCall("roman-counter", "decrement", [], deployer)
        ]);
        assertEquals(block.receipts.length, 2);
        assertEquals(block.height, 2);
        block.receipts[1].result.expectErr().expectAscii("Ancient Romans did not use 0 and negative numbers")
    },
});
