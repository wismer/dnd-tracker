<script setup lang="ts">
import { DndTrackerApiClient } from '../utils/api-client'
const client = new DndTrackerApiClient()
const adventures = await client.getAdventures()
</script>

<template>
  <h1>poop</h1>
</template>
